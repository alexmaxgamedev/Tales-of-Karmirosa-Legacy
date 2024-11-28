extends Control

signal change_button_pressed(action_name, line)

var input_name : String

onready var key : Label = $Key
onready var change_button : Button = $Change

func _ready() -> void:
	input_name = self.get_name().to_lower().replace(" ", "_")
	ErrorManager.check_errors(change_button.connect("pressed", self, "_on_Change_Button_pressed"))

func set_key_text(text : String) -> void:
	key.set_text(text)

func _on_Change_Button_pressed() -> void:
	emit_signal("change_button_pressed", input_name, self)
