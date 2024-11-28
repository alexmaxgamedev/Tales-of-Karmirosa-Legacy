extends Spatial

onready var health_pack_mesh : MeshInstance = $Mesh
onready var area : Area = $Mesh/Area
onready var pickup_sound : AudioStreamPlayer = $Sound
onready var timer : Timer = $Timer

var health_pack_is_taken : bool = false

func _on_Area_body_entered(body) -> void:
	if body.is_in_group("Player") and health_pack_is_taken == false and body.health.has_less_health():
		health_pack_is_taken = true
		body.health.add_health(int(rand_range(15, 26)))
		pickup_sound.play()
		
		health_pack_mesh.set_visible(false)
		area.set_deferred("monitoring", false)
		
		timer.start()
		
		yield(timer, "timeout")
		
		queue_free()
