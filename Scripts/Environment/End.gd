extends Area

func _on_Area_body_entered(body) -> void:
	if body.is_in_group("Player"):
		body.interface.show_win_panel()
