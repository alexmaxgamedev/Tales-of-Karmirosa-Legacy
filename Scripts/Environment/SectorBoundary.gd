extends Area

export var updated_sector_id : int = 0

func _ready() -> void:
	ErrorManager.check_errors(connect("body_entered", self, "_on_Area_body_entered"))

func _on_Area_body_entered(body) -> void:
	if body.is_in_group("Movable") and body.has_method("change_sector_id"):
		body.change_sector_id(updated_sector_id)
