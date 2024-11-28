extends Node

export var sectors_to_disable : Array = []
export var enemy_sectors_to_disable : PoolIntArray = []
export var interactable_sectors_to_disable : PoolIntArray = []

func _ready() -> void:
	for sector in sectors_to_disable:
		var temp_sector = get_node(sector)
		temp_sector.set_visible(false)

	for enemy_sector in enemy_sectors_to_disable:
		EnemyStats.set_enemy_state(false, enemy_sector)

	for interactable_sector in interactable_sectors_to_disable:
		InteractableStats.set_interactable_state(false, interactable_sector)
