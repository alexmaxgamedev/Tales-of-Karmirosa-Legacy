extends Spatial

export var color : Color
export var type : String

export var door_path : NodePath
export var second_keypad_path : NodePath

onready var mesh : MeshInstance = $Mesh
onready var open_sound : AudioStreamPlayer = $Audio

onready var door : Spatial = get_node(door_path)
onready var second_keypad : Spatial = get_node(second_keypad_path)

var is_activated : bool = false

func _ready() -> void:
	mesh.set_surface_material(0, mesh.get_surface_material(0).duplicate())
	mesh.set_surface_material(1, mesh.get_surface_material(1).duplicate())
	
	change_color(0, color)
	change_color(1, Color("b61d1d"))

func _on_Area_body_entered(body) -> void:
	if body.is_in_group("Player") and body.inventory.has_key(type) and is_activated == false:
		is_activated = true
		change_color(1, Color("41e100"))
		open_sound.play()
		door.make_door_openable()
		second_keypad.change_color(1, Color("41e100"))
		second_keypad.is_activated = true

func change_color(surface : int, surface_color : Color) -> void:
	mesh.get_surface_material(surface).set_albedo(surface_color)
