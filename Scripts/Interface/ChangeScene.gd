extends Button

export var level_name : String

func _ready() -> void:
	ErrorManager.check_errors(self.connect("pressed", self, "change_scene"))

func change_scene() -> void:
	LevelManager.load_level(level_name)
