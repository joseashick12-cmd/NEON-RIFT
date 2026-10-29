extends CharacterBody3D

const SPEED := 8.5
const JUMP_VELOCITY := 8.0
const DASH_SPEED := 18.0
const GRAVITY := 22.0
var dash_timer := 0.0

func _physics_process(delta: float) -> void:
    if not is_on_floor():
        velocity.y -= GRAVITY * delta
    elif Input.is_action_just_pressed("jump"):
        velocity.y = JUMP_VELOCITY
    var v := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
    var dir := Vector3(v.x, 0, v.y)
    if dir.length() > 0.1:
        velocity.x = dir.x * SPEED
        velocity.z = dir.z * SPEED
        rotation.y = atan2(-dir.x, -dir.z)
    else:
        velocity.x = move_toward(velocity.x, 0.0, SPEED * 5.0 * delta)
        velocity.z = move_toward(velocity.z, 0.0, SPEED * 5.0 * delta)
    if Input.is_action_just_pressed("dash") and dash_timer <= 0.0:
        dash_timer = 0.28
        var dash_dir := dir.normalized() if dir.length() > 0.1 else -transform.basis.z
        velocity.x = dash_dir.x * DASH_SPEED
        velocity.z = dash_dir.z * DASH_SPEED
    dash_timer = maxf(0.0, dash_timer - delta)
    move_and_slide()
