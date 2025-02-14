extends Area

export var disable : bool = false
export var sector_id : int = 0

export var sector_path : NodePath
onready var sector : Spatial = get_node(sector_path)

func _ready() -> void:
	ErrorManager.check_errors(connect("body_entered", self, "_on_Area_body_entered"))

func _on_Area_body_entered(body) -> void:
	if body.is_in_group("Player"):
		if disable == true and sector.is_visible() == true:
			sector.set_visible(false)
			EnemyStats.set_enemy_state(false, sector_id)
			InteractableStats.set_interactable_state(false, sector_id)
		elif disable == false and sector.is_visible() == false:
			sector.set_visible(true)
			EnemyStats.set_enemy_state(true, sector_id)
			InteractableStats.set_interactable_state(true, sector_id)
