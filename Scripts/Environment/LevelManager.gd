extends Node

signal level_changed

func load_level(index: String) -> void:
	refresh_mouse_cursor()
	
	match index:
		"Main Menu"      : ErrorManager.check_errors(get_tree().change_scene("res://Scenes/Main Menu.tscn"))
		"Level 1"        : ErrorManager.check_errors(get_tree().change_scene("res://Scenes/Level 1/Level 1.tscn"))
		"Level 1 Intro"  : ErrorManager.check_errors(get_tree().change_scene("res://Scenes/Level 1/Level 1 Intro.tscn"))
		"Level 1 Outro"  : ErrorManager.check_errors(get_tree().change_scene("res://Scenes/Level 1/Level 1 Outro.tscn"))
		"Credits"        : ErrorManager.check_errors(get_tree().change_scene("res://Scenes/Credits.tscn"))

	emit_signal("level_changed")
	
	
func restart_current_level() -> void:
	refresh_mouse_cursor()
	ErrorManager.check_errors(get_tree().reload_current_scene())
	
	emit_signal("level_changed")

func get_current_level_name() -> String:
	return get_tree().get_current_scene().get_name()

func refresh_mouse_cursor() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func quit() -> void:
	get_tree().quit()
