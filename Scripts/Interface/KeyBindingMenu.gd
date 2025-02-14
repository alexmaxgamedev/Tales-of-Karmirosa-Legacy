extends Control

var binding : String
var button : Button

var key_event : InputEventKey
var mouse_event : InputEventMouseButton

func _ready():
	self.set_process_input(false)

	for index in self.get_child_count():
		button = self.get_child(index).get_child(1)
		binding = button.get_parent().get_name()

		match get_event_suffix(SettingsData.input_bindings[binding]):
			"_k":
				key_event = InputEventKey.new()
				modify_key_binding(binding, key_event, get_event_value(SettingsData.input_bindings[binding]))
			"_m":
				mouse_event = InputEventMouseButton.new()
				modify_mouse_binding(binding, mouse_event, get_event_value(SettingsData.input_bindings[binding]))

		ErrorManager.check_errors(button.connect("pressed", self, "_on_key_bind_button_pressed", [button]))

func _input(event):
	if event.is_pressed() == true:
		if event is InputEventKey:
			modify_key_binding(binding, event, event.scancode)
			SettingsData.input_bindings[binding] = str(event.scancode) + "_k"

		if event is InputEventMouseButton:
			modify_mouse_binding(binding, event, event.button_index)
			SettingsData.input_bindings[binding] = str(event.button_index) + "_m"

		self.accept_event()
		self.set_process_input(false)

func _on_key_bind_button_pressed(bind_button : Button) -> void:
	button = bind_button
	binding = button.get_parent().get_name()
	bind_button.set_text("....")
	self.set_process_input(true)

func modify_mouse_binding(mouse_binding : String, event : InputEventMouse, value : int) -> void:
	event.set_button_index(value)
	InputMap.action_erase_events(mouse_binding)
	InputMap.action_add_event(mouse_binding, event)
	button.set_text("Mouse " + str(event.button_index))

func modify_key_binding(key_binding : String, event : InputEventKey, value : int) -> void:
	event.set_scancode(value)
	InputMap.action_erase_events(key_binding)
	InputMap.action_add_event(key_binding, event)
	button.set_text(OS.get_scancode_string(event.scancode))

func get_event_suffix(text : String) -> String:
	return text.substr(text.length() - 2, 2)

func get_event_value(text : String) -> int:
	return int(text.substr(0, text.length() - 2))
