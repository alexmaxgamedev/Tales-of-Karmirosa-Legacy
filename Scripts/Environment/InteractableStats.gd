extends Node

var interactables : Array = []

func _init() -> void:
	ErrorManager.check_errors(LevelManager.connect("level_changed", self, "reset_interactables"))

func add_interactable(interactable : RigidBody) -> void:
	interactables.push_back(interactable)

func set_interactable_state(state : bool, sector_id : int) -> void:
	for interactable in interactables:
		if interactable.get_sector_id() == sector_id:
			interactable.set_visible(state)

func reset_interactables() -> void:
	interactables.clear()

func print_interactables() -> void:
	for interactable in interactables:
		print(interactable.get_name())
