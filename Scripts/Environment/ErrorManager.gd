extends Node

func check_errors(error_code: int) -> void:
	if error_code != OK:
		push_error("Game exited with error code: " + str(error_code))
		get_tree().quit()
