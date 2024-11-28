extends KinematicBody

export var sector_id : int = 0

export var pursue_range : float = 120.0
export var walk_shoot_distance : float = 65.0 
export var stop_distance : float = 12.0

export var speed : float = 8.0
export var gravity : float = 60.0

onready var audio : AudioStreamPlayer3D = $Audio
onready var sprite : Sprite3D = $Sprite
onready var raycast : RayCast = $Raycast
onready var collision : CollisionShape = $Collision
onready var animations : AnimationPlayer = $Animation

var health : int = 100
var distance : float

var is_hurt : bool = false

var can_deactivate : bool = true
var can_pursue_player : bool = false
var player_visible : bool = false

var fall : Vector3
var movement : Vector3
var movement_debug : Vector3
var direction_towards_player : Vector3

var ray_collider : Object

var frame_counter : int = 0
var interval : int = 10

func _ready() -> void:
	EnemyStats.add_enemy(self)
	raycast.set_cast_to(Vector3(0, 0, -pursue_range))
	animations.play("idle")
	frame_counter = 5

func _physics_process(delta) -> void:
	frame_counter += 1

	if frame_counter == interval:
		raycast.force_raycast_update()
		ray_collider = raycast.get_collider()
	
		if ray_collider != null and ray_collider.get_name() == "Player":
			can_pursue_player = true
			player_visible = true
			can_deactivate = false
		else:
			player_visible = false
			can_deactivate = true

		frame_counter = 0

	if is_hurt:
		return

	raycast.look_at(PlayerStats.player.camera.global_transform.origin, Vector3.UP)

	if can_pursue_player == true:
		direction_towards_player = PlayerStats.player.translation - self.translation
		direction_towards_player = direction_towards_player.normalized()
		direction_towards_player.y = 0.0
		distance = self.translation.distance_to(PlayerStats.player.translation)

		if distance >= stop_distance:
			if self.is_on_floor():
				fall.y = -1.0
			else:
				fall.y -= gravity * delta

			movement = (direction_towards_player * speed) + fall

			movement_debug = self.move_and_slide(movement, Vector3.UP, false, 4, 0.8, false)

		if distance >= pursue_range:
			can_pursue_player = false

		if distance > walk_shoot_distance:
			animations.play("walk")
		if distance <= walk_shoot_distance and distance > stop_distance:
			if player_visible == true:
				animations.play("walk_shoot")
			else:
				animations.play("walk")
		if distance <= stop_distance:
			if player_visible == true:
				animations.play("stand_shoot")
			else:
				animations.play("idle")
	else:
		animations.play("idle")

func die() -> void:
	collision.set_deferred("disabled", true)
	animations.play("die")
	
	can_deactivate = true
	set_physics_process(false)

func damage(value : int) -> void:
	if health > 0:
		is_hurt = true
		health -= value
	if is_hurt == true:
		animations.play("hurt")
	if health <= 0:
		die()

func dehurt() -> void:
	is_hurt = false

func schoot_player() -> void:
	raycast.force_raycast_update()
	ray_collider = raycast.get_collider()

	if ray_collider != null and ray_collider.is_in_group("Player"):
		PlayerStats.player.health.damage_player(int(rand_range(0, 6)))
		
func change_sector_id(value : int) -> void:
	sector_id = value
	
func get_sector_id() -> int:
	return sector_id
