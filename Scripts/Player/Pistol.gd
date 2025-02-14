extends Control

export var max_ammo : int = 150
var current_ammo : int

export var bullet_impulse_force : float = 150.0
export var ammo_counter_path : NodePath

onready var weapon_audio : AudioStreamPlayer = $Audio
onready var animation : AnimationPlayer = $Animation
onready var ammo_counter : Label = get_node(ammo_counter_path)

var collider : Object
var raycast : RayCast

var position : Vector3
var impulse : Vector3

func _ready() -> void:
	current_ammo = max_ammo
	ammo_counter.set_text(str(current_ammo))
	raycast = PlayerStats.player.raycast

func _process(_delta) -> void:
	if Input.is_action_just_pressed("fire") and current_ammo > 0 and animation.is_playing() == false:
		animation.play("fire")
		weapon_audio.play()
		decrease_ammo(1)
		check_collisions()

func add_ammo(amount : int) -> void:
	if current_ammo + amount > max_ammo:
		current_ammo += max_ammo - current_ammo
	else:
		current_ammo += amount
	
	ammo_counter.set_text(str(current_ammo))

func decrease_ammo(amount : int) -> void:
	current_ammo -= amount
	ammo_counter.set_text(str(current_ammo))

func has_less_ammo() -> bool:
	return current_ammo < max_ammo

func check_collisions() -> void:
	raycast.force_raycast_update()
	collider = raycast.get_collider()

	if collider != null:
		if collider.is_in_group("Enemy"):
			collider.damage(int(rand_range(30, 40)))
		if collider is RigidBody:
			position = (raycast.get_collision_point() - raycast.global_transform.origin).normalized()
			impulse = -raycast.get_collision_normal().normalized() * bullet_impulse_force
			collider.apply_impulse(position, impulse)
