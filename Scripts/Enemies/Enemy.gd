extends KinematicBody

export var sector_id : int = 0

enum priority_list {
	Guard = 1,
	Boss = 2,
}

export (priority_list) var priority_type : int = priority_list.Guard

export var walk_distance : float  = 120.0
export var walk_shoot_distance : float = 65.0
export var stop_distance : float = 12.0

export var speed : float = 8.0
export var health : int = 100
export var max_damage : int = 5
export var has_walk_fire : bool = true
export var is_boss : bool = false

onready var audio : AudioStreamPlayer3D = $Audio
onready var sprite : Sprite3D = $Sprite
onready var raycast : RayCast = $Raycast
onready var collision : CollisionShape = $Collision
onready var animation : AnimationPlayer = $Animation

var distance : float

var fall : Vector3
var movement : Vector3
var movement_debug : Vector3
var direction_to_player : Vector3

var boss_battle : Area
var collider : Object

var frame_counter : int = 0
var interval : int = 10

var can_move : float = 0
var start_anim : int = 0
var start_move : float = 0.0

var animations : Array = [
	"idle",
	"walk",
	"walk_fire",
	"stand_fire",
	"recover",
]

var indexes : Array = [0, 1, 2, 3, 4]
var switch_index : int = 2
var anim_index : int = 0

func _ready() -> void:
	EnemyStats.add_enemy(self)
	set_priority_order()
	
	raycast.set_cast_to(Vector3(0.0, 0.0, -walk_distance))
	animation.play("idle")
	
	if is_boss == true:
		boss_battle = get_node("../../Boss Battle")

	if has_walk_fire == false:
		switch_index = 1

func _physics_process(_delta) -> void:
	frame_counter += 1

	if frame_counter == interval:
		get_raycast_info()

		if is_player_visible():
			indexes[1] = 1
			indexes[2] = switch_index
			indexes[3] = 3
			start_anim = 1
			start_move = 1.0
		else:
			indexes[1] = 1
			indexes[2] = 1
			indexes[3] = 0
	
		direction_to_player = self.translation.direction_to(PlayerStats.player.translation)
		direction_to_player.y = 0.0

		distance = self.translation.distance_to(PlayerStats.player.translation)

		anim_index = 0
		can_move = 0.0

		if distance < walk_distance:
			anim_index = 1 * start_anim
			can_move = 1.0 * start_move
		if distance < walk_shoot_distance:
			anim_index = 2 * start_anim
			can_move = 1.0 * start_move
		if distance < stop_distance:
			anim_index = 3 * start_anim
			can_move = 0.0

		animation.play(animations[indexes[anim_index]])

		frame_counter = 0

	fall.y = -0.1
	movement = (direction_to_player * speed * can_move) + fall
	movement_debug = self.move_and_slide(movement, Vector3.UP, false, 4, 0.8, false)

	raycast.look_at(PlayerStats.player.camera.global_transform.origin, Vector3.UP)

func damage(value : int) -> void:
	if health > 0:
		health -= value
		animation.play("recover")
		direction_to_player = Vector3.ZERO
		self.set_physics_process(false)
	if health <= 0:
		die()

func die() -> void:
	animation.play("die")
	collision.set_deferred("disabled", true)
	self.set_physics_process(false)

	if is_boss == true:
		boss_battle.increase_killed_boss_count()

func recover() -> void:
	self.set_physics_process(true)

func fire_at_player() -> void:
	get_raycast_info()

	if is_player_visible():
		PlayerStats.player.health.damage_player(int(rand_range(0, max_damage + 1)))

func get_raycast_info() -> void:
	raycast.force_raycast_update()
	collider = raycast.get_collider()

func is_player_visible() -> bool:
	return collider != null and collider.is_in_group("Player")

func set_priority_order() -> void:
	match priority_type:
		priority_list.Guard:
			frame_counter = 5
		priority_list.Boss:
			frame_counter = 0

func change_sector_id(value : int) -> void:
	sector_id = value

func get_sector_id() -> int:
	return sector_id
