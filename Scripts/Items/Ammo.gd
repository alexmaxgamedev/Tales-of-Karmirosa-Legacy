extends Spatial

onready var mesh : MeshInstance = $Mesh
onready var area : Area = $Mesh/Area
onready var timer : Timer = $Timer
onready var pickup_sound : AudioStreamPlayer = $Sound

var ammo_is_taken : bool = false

func _on_Area_body_entered(body) -> void:
	if body.is_in_group("Player") and ammo_is_taken == false and body.weapon.has_less_ammo():
		ammo_is_taken = true
		
		body.weapon.add_ammo(int(rand_range(8, 16)))
		pickup_sound.play()
		
		mesh.set_visible(false)
		area.set_deferred("monitoring", false)

		timer.start()
		
		yield(timer, "timeout")

		queue_free()
