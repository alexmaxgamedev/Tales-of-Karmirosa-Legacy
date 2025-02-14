extends KinematicBody

export var walk_speed : float = 18.0
export var run_speed : float = 24.0
export var jump_speed : float = 20.0
export var gravity : float = 60.0

var fall : Vector3
var movement : Vector3
var movement_debug : Vector3
var direction : Vector3
var snap : Vector3

var temporary_speed : float
var temporary_fov : float

var run_fov_add_amount : int = 10
var normal_fov : int

var mouse_axis : Vector2
var mouse_sensitivity : Vector2

var push_power : float = 0.2
var collision : KinematicCollision
var collider : Object

onready var camera : Camera = $Camera
onready var raycast : RayCast = $Camera/Raycast

onready var interface : Control = $"../../../Interface"
onready var gameplay : Control = $"../../../Interface/Gameplay"

onready var inventory : Node = $"../../../Interface/Inventory"
onready var health : ProgressBar = $"../../../Interface/Gameplay/Health Bar"

onready var weapon : Control = $"../../../Interface/Gameplay/Pistol"
onready var crosshair : TextureRect = $"../../../Interface/Crosshair"

func _ready() -> void:
	PlayerStats.player = self
	
	change_player_settings()
	
	camera.set_fov(normal_fov)
	temporary_fov = camera.get_fov()
	
	temporary_speed = walk_speed

func _input(event) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		mouse_axis = event.relative
		
		if mouse_axis.length() > 0.0:
			self.rotate_y(deg2rad(-mouse_axis.x * mouse_sensitivity.x))
			camera.rotate_x(deg2rad(-mouse_axis.y * mouse_sensitivity.y))
			camera.rotation.x = clamp(camera.rotation.x, -1.57, 1.57)
	
			mouse_axis = Vector2.ZERO

func _process(delta) -> void:
	direction = Vector3.ZERO

	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	if Input.is_action_pressed("move_back"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	if Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	
	direction = direction.normalized()
	
	if Input.is_action_just_pressed("run") and Input.is_action_pressed("move_forward"):
		temporary_speed = run_speed
		temporary_fov = normal_fov + run_fov_add_amount
	
	if Input.is_action_just_released("run") or Input.is_action_just_released("move_forward"):
		reset_walk_speed_fov()
	
	if self.is_on_floor():
		snap = -self.get_floor_normal()
		fall.y = 0.0
	else:
		snap = Vector3.DOWN
		fall.y -= gravity * delta
		
	if Input.is_action_just_pressed("jump") and self.is_on_floor():
		snap = Vector3.ZERO
		fall.y = jump_speed

	movement = (direction * temporary_speed) + fall

	movement_debug = self.move_and_slide_with_snap(movement, snap, Vector3.UP, false, 4, 0.785, false)
	camera.set_fov(lerp(camera.fov, temporary_fov, delta * 12.0))

func _physics_process(delta) -> void:
	for index in get_slide_count():
		collision = get_slide_collision(index)
		collider = collision.collider
		
		if collider is RigidBody:
			collider.set_deferred("sleeping", false)
			collider.apply_central_impulse(-collision.normal.normalized() * push_power * delta)

func change_player_settings() -> void:
	normal_fov = SettingsData.config_values.fov

	mouse_sensitivity.x = SettingsData.config_values.mouse_sensitivity
	mouse_sensitivity.y = SettingsData.config_values.mouse_sensitivity
	mouse_sensitivity.y = abs(mouse_sensitivity.y)
	
	if SettingsData.config_values.invert_mouse == true:
		mouse_sensitivity.y *= -1.0
	
	gameplay.set_visible(SettingsData.config_values.show_gameplay)
	crosshair.set_visible(SettingsData.config_values.show_crosshair)

func reset_walk_speed_fov() -> void:
	temporary_speed = walk_speed
	temporary_fov = normal_fov
