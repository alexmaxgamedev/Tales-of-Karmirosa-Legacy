extends RigidBody

export var sector_id : int = 0

func _ready() -> void:
	InteractableStats.add_interactable(self)

func change_sector_id(value : int) -> void:
	sector_id = value
	
func get_sector_id() -> int:
	return sector_id
