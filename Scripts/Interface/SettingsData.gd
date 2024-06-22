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
	"fast_graphics" : false,
	"ambient_occlusion" : false,
	"ui_scaling" : false,
	"msaa_4x" : false,
	"screen_filter" : false,
	"resolution_scale" : 1.0,
	"max_fps" : 0,
	"windowed_size_x" : 0,
	"windowed_size_y" : 0
}

var config : ConfigFile
var config_values_list : Array

var error_check : int

func _init() -> void:
	config = ConfigFile.new()
	config_values_list = config_values.keys()

func load_settings() -> void:
	error_check = config.load("user://settings.cfg")
	
	if error_check != OK:
		push_error("Could not load game settings! Error code: " + str(error_check))
		return

	for config_value in config_values_list:
		if config.has_section("settings"):
			if config.has_section_key("settings", config_value):
				config_values[config_value] = config.get_value("settings", config_value)

func save_settings() -> void:
	for config_value in config_values_list:
		config.set_value("settings", config_value, config_values[config_value])

	ProjectSettings.set_setting("rendering/quality/shading/force_vertex_shading", config_values.fast_graphics)
	
	error_check = ProjectSettings.save_custom("user://override.godot")
	
	if error_check != OK:
		push_error("Could not save overrided game settings! Error code: " + str(error_check))
		return
	
	error_check = config.save("user://settings.cfg")
	
	if error_check != OK:
		push_error("Could not save game settings! Error code: " + str(error_check))
		return
