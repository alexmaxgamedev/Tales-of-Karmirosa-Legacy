extends Node

var config_values : Dictionary = {
	"master_volume" : 0.8,
	"music_volume" : 0.5,
	"sfx_volume" : 0.4,
	"fov" : 85.0,
	"mouse_sensitivity" : 0.11,
	"invert_mouse" : false,
	"show_gameplay" : true,
	"show_crosshair" : true,
	"fullscreen" : true,
	"v_sync" : true,
	"show_fps" : false,
	"vertex_lighting" : false,
	"ambient_occlusion" : false,
	"ui_scaling" : false,
	"msaa" : false,
	"screen_filter" : false,
	"resolution_scale" : 1.0,
	"max_fps" : 241,
	"windowed_size_x" : 0,
	"windowed_size_y" : 0,
}

var input_bindings : Dictionary = {
	"move_forward" : "87_k",
	"move_left" : "65_k",
	"move_back" : "83_k",
	"move_right" : "68_k",
	"run" : "16777237_k",
	"jump" : "32_k",
	"fire" : "1_m",
	"pause" : "16777217_k",
}

var config : ConfigFile

var config_values_list : Array
var input_bindings_list : Array

var error_check : int

func _init() -> void:
	config = ConfigFile.new()

	config_values_list = config_values.keys()
	input_bindings_list = input_bindings.keys()
	
	load_settings()

	AudioServer.set_bus_volume_db(0, linear2db(config_values.master_volume))
	AudioServer.set_bus_volume_db(1, linear2db(config_values.music_volume))
	AudioServer.set_bus_volume_db(2, linear2db(config_values.sfx_volume))

func load_settings() -> void:
	error_check = config.load("user://settings.cfg")

	if error_check != OK:
		push_warning("Can't load settings! Using default values. Error code: " + str(error_check))
		return

	for config_value in config_values_list:
		if config.has_section("settings"):
			if config.has_section_key("settings", config_value):
				config_values[config_value] = config.get_value("settings", config_value)

	for input_binding in input_bindings_list:
		if config.has_section("input_bindings"):
			if config.has_section_key("input_bindings", input_binding):
				input_bindings[input_binding] = config.get_value("input_bindings", input_binding)

func save_settings() -> void:
	for config_value in config_values_list:
		config.set_value("settings", config_value, config_values[config_value])

	for input_binding in input_bindings_list:
		config.set_value("input_bindings", input_binding, input_bindings[input_binding])
	
	error_check = config.save("user://settings.cfg")

	if error_check != OK:
		push_warning("Can't save settings! Error code: " + str(error_check))
		return
