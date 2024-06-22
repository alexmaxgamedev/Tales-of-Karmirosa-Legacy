extends Control

export var max_ammo : int = 150
var current_ammo : int

export var bullet_impulse_force : float = 150.0
export var ammo_counter_path : NodePath

onready var weapon_audio : AudioStreamPlayer = $Audio
onready var weapon_animation : AnimationPlayer = $Animation
onready var ammo_counter : Label = get_node(ammo_counter_path)

var collider : Object
var raycast : RayCast

func _ready() -> void:
	current_ammo = max_ammo
	ammo_counter.set_text(str(current_ammo))
	raycast = PlayerStats.player.raycast

func _process(_delta) -> void:
	if Input.is_action_just_pressed("fire") and !weapon_animation.is_playing() and current_ammo > 0:
		weapon_animation.play("shoot")
		weapon_audio.play()
		
		raycast.force_raycast_update()
		collider = raycast.get_collider()
		
		current_ammo -= 1
		ammo_counter.set_text(str(current_ammo))

		if raycast.is_colliding() and collider.has_method("damage"):
			collider.damage(int(rand_range(30, 40)))
		
		if raycast.is_colliding() and collider is RigidBody:
			collider.apply_impulse((raycast.get_collision_point() - raycast.global_transform.origin).normalized(), -raycast.get_collision_normal().normalized() * bullet_impulse_force)
			
func add_ammo(amount : int) -> void:
	if current_ammo + amount > max_ammo:
		current_ammo += max_ammo - current_ammo
	else:
		current_ammo += amount
	
	ammo_counter.set_text(str(current_ammo))

func has_less_ammo() -> bool:
	return current_ammo < max_ammo

