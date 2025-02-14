extends Spatial

export var can_be_opened : bool = true

var number_of_bodies_inside : int = 0

var start_status : bool
var interpolation_status : bool

onready var door : RigidBody = $Body
onready var tween : Tween = $Tween

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

func move_door(position : Vector3) -> void:
	if tween.is_inside_tree() == true:
		interpolation_status = tween.interpolate_property(door, "translation", door.get_translation(), position, 0.5, Tween.TRANS_SINE, Tween.EASE_IN)
		start_status = tween.start()

func make_door_openable() -> void:
	can_be_opened = true
