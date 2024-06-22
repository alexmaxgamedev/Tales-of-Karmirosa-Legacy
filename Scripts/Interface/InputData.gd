extends Node

var input_keycodes : Dictionary = {
	"move_left" : 65,
	"move_right" : 68,
	"move_forward" : 87,
	"move_back" : 83,
	"run" : 16777237,
	"jump" : 32,
	"fire" : 1,
	"pause" : 16777217
}

var input_mouse_states : Dictionary = {
	"move_left" : false,
	"move_right" : false,
	"move_forward" : false,
	"move_back" : false,
	"run" : false,
	"jump" : false,
	"fire" : true,
	"pause" : false
}

var input_config : ConfigFile
var keycode_list : Array

var error_check : int

func _init() -> void:
	input_config = ConfigFile.new()
	keycode_list = input_keycodes.keys()

func load_input_settings() -> void:
	error_check = input_config.load("user://input_config.cfg")
	
	if error_check != OK:
		push_error("Could not load input settings! Error code: " + str(error_check))
		return
	
	for input_keycode in keycode_list:
		if input_config.has_section("input_keycodes"):
			if input_config.has_section_key("input_keycodes", input_keycode):
				input_keycodes[input_keycode] = input_config.get_value("input_keycodes", input_keycode)
		
		if input_config.has_section("input_mouse_states"):
			if input_config.has_section_key("input_mouse_states", input_keycode):
				input_mouse_states[input_keycode] = input_config.get_value("input_mouse_states", input_keycode)

func save_input_settings() -> void:
	for input_keycode in keycode_list:
		input_config.set_value("input_keycodes", input_keycode, input_keycodes[input_keycode])
		input_config.set_value("input_mouse_states", input_keycode, input_mouse_states[input_keycode])

	error_check = input_config.save("user://input_config.cfg")
	
	if error_check != OK:
		push_error("Could not save input settings! Error code: " + str(error_check))
		return
