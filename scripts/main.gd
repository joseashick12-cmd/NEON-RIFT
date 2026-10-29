extends Node3D

var player: CharacterBody3D
var status_label: Label

func _ready() -> void:
    _make_world()
    _make_player()
    _make_hud()

func _material(color: Color, glow: bool = false) -> StandardMaterial3D:
    var m := StandardMaterial3D.new()
    m.albedo_color = color
    if glow:
        m.emission_enabled = true
        m.emission = color
        m.emission_energy_multiplier = 2.2
    return m

func _make_world() -> void:
    var env := WorldEnvironment.new()
    var e := Environment.new()
    e.background_mode = Environment.BG_SKY
    var sky := Sky.new()
    var sky_mat := ProceduralSkyMaterial.new()
    sky_mat.sky_top_color = Color(0.01, 0.015, 0.07)
    sky_mat.sky_horizon_color = Color(0.08, 0.02, 0.18)
    sky.sky_material = sky_mat
    e.sky = sky
    e.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    e.ambient_light_color = Color(0.3, 0.4, 0.8)
    e.ambient_light_energy = 0.7
    env.environment = e
    add_child(env)
    var sun := DirectionalLight3D.new()
    sun.rotation_degrees = Vector3(-55, -25, 0)
    sun.light_energy = 1.1
    add_child(sun)
    var floor := MeshInstance3D.new()
    var plane := PlaneMesh.new()
    plane.size = Vector2(42, 42)
    floor.mesh = plane
    floor.material_override = _material(Color(0.025, 0.035, 0.11))
    add_child(floor)
    var body := StaticBody3D.new()
    var collision := CollisionShape3D.new()
    var shape := BoxShape3D.new()
    shape.size = Vector3(42, 0.4, 42)
    collision.shape = shape
    collision.position.y = -0.2
    body.add_child(collision)
    add_child(body)
    for i in range(-20, 21, 2):
        _add_line(Vector3(float(i), 0.025, 0), Vector3(0.025, 0.025, 42), Color(0.0, 0.75, 1.0, 0.8))
        _add_line(Vector3(0, 0.025, float(i)), Vector3(42, 0.025, 0.025), Color(0.65, 0.08, 1.0, 0.75))
    for i in range(12):
        var a := float(i) * TAU / 12.0
        var crystal := MeshInstance3D.new()
        var mesh := PrismMesh.new()
        mesh.size = Vector3(1.0, 2.8, 1.0)
        crystal.mesh = mesh
        crystal.position = Vector3(cos(a) * 12.0, 1.4, sin(a) * 12.0)
        crystal.rotation.y = a
        crystal.material_override = _material(Color(0.9, 0.08, 0.6), true)
        add_child(crystal)
    var core := MeshInstance3D.new()
    var sphere := SphereMesh.new()
    sphere.radius = 1.4
    sphere.height = 2.8
    core.mesh = sphere
    core.position = Vector3(0, 2.2, 0)
    core.material_override = _material(Color(0.0, 0.9, 1.0), true)
    add_child(core)
    var ring := MeshInstance3D.new()
    var torus := TorusMesh.new()
    torus.inner_radius = 1.8
    torus.outer_radius = 2.0
    ring.mesh = torus
    ring.position.y = 1.3
    ring.rotation_degrees.x = 90
    ring.material_override = _material(Color(0.8, 0.1, 1.0), true)
    add_child(ring)

func _add_line(pos: Vector3, size: Vector3, color: Color) -> void:
    var mesh_instance := MeshInstance3D.new()
    var box := BoxMesh.new()
    box.size = size
    mesh_instance.mesh = box
    mesh_instance.position = pos
    mesh_instance.material_override = _material(color, true)
    add_child(mesh_instance)

func _make_player() -> void:
    player = CharacterBody3D.new()
    player.name = "Player"
    player.position = Vector3(0, 1.0, 7.0)
    player.set_script(load("res://scripts/player.gd"))
    var collision := CollisionShape3D.new()
    var capsule := CapsuleShape3D.new()
    capsule.radius = 0.48
    capsule.height = 1.8
    collision.shape = capsule
    player.add_child(collision)
    var avatar := MeshInstance3D.new()
    var capsule_mesh := CapsuleMesh.new()
    capsule_mesh.radius = 0.48
    capsule_mesh.height = 1.8
    avatar.mesh = capsule_mesh
    avatar.material_override = _material(Color(0.0, 0.85, 1.0), true)
    player.add_child(avatar)
    var cam := Camera3D.new()
    cam.position = Vector3(0, 6.5, 11.0)
    cam.rotation_degrees = Vector3(-27, 0, 0)
    cam.current = true
    player.add_child(cam)
    add_child(player)

func _make_hud() -> void:
    var layer := CanvasLayer.new()
    add_child(layer)
    var title := Label.new()
    title.text = "NEON RIFT  //  BATTLE FOR THE CORE"
    title.position = Vector2(24, 20)
    title.add_theme_font_size_override("font_size", 24)
    title.add_theme_color_override("font_color", Color(0.2, 0.9, 1.0))
    layer.add_child(title)
    status_label = Label.new()
    status_label.text = "MOVE: WASD / ARROWS     JUMP: SPACE     DASH: SHIFT"
    status_label.position = Vector2(24, 56)
    status_label.add_theme_font_size_override("font_size", 16)
    status_label.add_theme_color_override("font_color", Color(0.9, 0.8, 1.0))
    layer.add_child(status_label)
    var note := Label.new()
    note.text = "ANDROID TEST BUILD  •  MULTIPLAYER PROTOTYPE"
    note.position = Vector2(24, 92)
    note.add_theme_font_size_override("font_size", 13)
    note.add_theme_color_override("font_color", Color(0.7, 0.75, 0.9))
    layer.add_child(note)
