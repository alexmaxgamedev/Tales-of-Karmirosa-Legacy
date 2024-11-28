extends VBoxContainer

signal key_selected(scancode)

onready var ui_input_lines : Dictionary = {
	"move_left" : $"Move Left",
	"move_right" : $"Move Right",
	"move_forward" : $"Move Forward",
	"move_back" : $"Move Back",
	"run" : $Run,
	"jump" : $Jump,
	"fire" : $Fire,
	"pause" : $Pause
}

export var key_selection_label_path : NodePath
onready var key_selection_label : Label = get_node(key_selection_label_path)

var current_keycode : int
var input_lines : Array

var key_event : InputEvent
var is_mouse_event : bool

func _ready() -> void:
	input_lines = ui_input_lines.keys()

	InputData.load_input_settings()
	set_process_input(false)

	for input_line in input_lines:
		ErrorManager.check_errors(ui_input_lines[input_line].connect("change_button_pressed", self, "_on_input_line_change_button_pressed"))
		is_mouse_event = InputData.input_mouse_states[input_line]
		change_action_key(input_line, InputData.input_keycodes[input_line], ui_input_lines[input_line])

func _input(event) -> void:
	if event.is_pressed() and event is InputEventKey:
		is_mouse_event = false
		emit_signal("key_selected", event.scancode)
	if event.is_pressed() and event is InputEventMouseButton:
		is_mouse_event = true
		emit_signal("key_selected", event.button_index)

func _on_input_line_change_button_pressed(action_name, line) -> void:
	set_process_input(true)
	show_key_change_menu(true)

	current_keycode = yield(self, "key_selected")
	change_action_key(action_name, current_keycode, line)

	InputData.input_keycodes[action_name] = current_keycode
	InputData.input_mouse_states[action_name] = is_mouse_event

	set_process_input(false)
	show_key_change_menu(false)

func change_action_key(action_name, keycode, line) -> void:
	InputMap.action_erase_events(action_name)

	if is_mouse_event == true:
		key_event = InputEventMouseButton.new()
		key_event.set_button_index(keycode)
		InputMap.action_add_event(action_name, key_event)
		line.set_key_text("Mouse " + str(key_event.get_button_index()))
	else:
		key_event = InputEventKey.new()
		key_event.set_scancode(keycode)
		InputMap.action_add_event(action_name, key_event)
		line.set_key_text(OS.get_scancode_string(keycode))

func show_key_change_menu(state : bool) -> void:
	key_selection_label.set_visible(state)
