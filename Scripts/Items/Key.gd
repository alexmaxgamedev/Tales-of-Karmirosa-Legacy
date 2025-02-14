extends Spatial

export var type : String
export var color : Color

onready var mesh : MeshInstance = $Mesh
onready var area : Area = $Mesh/Area
onready var timer : Timer = $Timer
onready var pickup_sound : AudioStreamPlayer = $Sound

var is_taken : bool = false

func _ready() -> void:
	mesh.set_surface_material(0, mesh.get_surface_material(0).duplicate())
	change_color(color)

func _on_Area_body_entered(body) -> void:
	if body.is_in_group("Player") and is_taken == false:
		is_taken = true
		body.inventory.give_key(type)
		pickup_sound.play()
		
		mesh.set_visible(false)
		area.set_deferred("monitoring", false)
		
		timer.start()
		
		yield(timer, "timeout")

		queue_free()

func change_color(surface_color : Color) -> void:
	mesh.get_surface_material(0).set_albedo(surface_color)
