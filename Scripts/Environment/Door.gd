extends Spatial

export var can_be_opened : bool = true

var number_of_bodies_inside : int = 0

var tween_start_status : bool
var tween_interpolation_status : bool

onready var door_tween : Tween = $Tween
onready var door_object : RigidBody = $Body

func _on_Area_body_entered(body) -> void:
	if body.is_in_group("Movable"):
		number_of_bodies_inside += 1
		
		if can_be_opened == true:
				move_door(Vector3(6.0, 0.0, 0.0))

func _on_Area_body_exited(body) -> void:
	if body.is_in_group("Movable"):
		number_of_bodies_inside -= 1

		if number_of_bodies_inside == 0:
			move_door(Vector3(0.0, 0.0, 0.0))

func move_door(door_position : Vector3) -> void:
	if door_tween.is_inside_tree() == true:
		tween_interpolation_status = door_tween.interpolate_property(door_object, "translation", door_object.get_translation(), door_position, 0.5, Tween.TRANS_SINE, Tween.EASE_IN)
		tween_start_status = door_tween.start()

func make_door_openable() -> void:
	can_be_opened = true
