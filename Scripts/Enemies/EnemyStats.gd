extends Node

var enemies : Array = []

func _init() -> void:
	ErrorManager.check_errors(LevelManager.connect("level_changed", self, "reset_enemies"))

func add_enemy(enemy : KinematicBody) -> void:
	enemies.push_back(enemy)

func set_enemy_state(state : bool, sector_id : int) -> void:
	for enemy in enemies:
		if enemy.get_sector_id() == sector_id:
			enemy.set_physics_process(state)
			enemy.set_visible(state)

func reset_enemies() -> void:
	enemies.clear()

func print_enemies() -> void:
	for enemy in enemies:
		print(enemy.get_name())
