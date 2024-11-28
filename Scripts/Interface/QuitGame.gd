extends Button

func _ready() -> void:
	ErrorManager.check_errors(self.connect("pressed", self, "quit_game"))

func quit_game() -> void:
	LevelManager.quit()
