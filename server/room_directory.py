"""NEON RIFT private room directory prototype."""
from __future__ import annotations
import os, secrets, string, time
from threading import Lock
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
app = FastAPI(title="NEON RIFT Room Directory", version="0.1.0")
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_credentials=False, allow_methods=["GET", "POST"], allow_headers=["*"])
rooms: dict[str, dict] = {}
lock = Lock()
ROOM_TTL = int(os.getenv("NEON_RIFT_ROOM_TTL", "21600"))
MATCH_HOST = os.getenv("NEON_RIFT_MATCH_HOST", "")
MATCH_PORT = int(os.getenv("NEON_RIFT_MATCH_PORT", "24567"))
class CreateRoom(BaseModel):
    host: str = Field(min_length=3, max_length=253)
    port: int = Field(default=24567, ge=1024, le=65535)
def cleanup() -> None:
    now = time.time()
    with lock:
        for code in list(rooms):
            if rooms[code]["expires_at"] < now: del rooms[code]
@app.get("/health")
def health(): return {"ok": True, "service": "neon-rift-room-directory"}
def new_code() -> str: return "".join(secrets.choice(string.ascii_uppercase + string.digits) for _ in range(6))
@app.post("/rooms")
def create_room(payload: CreateRoom):
    cleanup()
    with lock:
        code = new_code()
        while code in rooms: code = new_code()
        rooms[code] = {"host": payload.host, "port": payload.port, "expires_at": time.time() + ROOM_TTL}
    return {"code": code, "host": payload.host, "port": payload.port, "expires_in": ROOM_TTL}
@app.get("/rooms/{code}")
def get_room(code: str):
    cleanup(); normalized = code.strip().upper()
    with lock: room = rooms.get(normalized)
    if not room: raise HTTPException(status_code=404, detail="Room not found or expired")
    return {"host": room["host"], "port": room["port"], "expires_at": room["expires_at"]}
@app.get("/matchmaking")
def matchmaking():
    if not MATCH_HOST: raise HTTPException(status_code=503, detail="Set NEON_RIFT_MATCH_HOST to a public game server IP")
    return {"host": MATCH_HOST, "port": MATCH_PORT}
