extends Control

onready var v_sync_toggle : CheckBox = $Tabs/Graphics/List/Vsync
onready var show_fps_toggle : CheckBox = $"Tabs/Graphics/List/Show FPS"
onready var ui_scaling_toggle : CheckBox = $"Tabs/Graphics/List/UI Scaling"
onready var msaa_4x_toggle : CheckBox = $"Tabs/Graphics/List/4X MSAA"
onready var fullscreen_toggle : CheckBox = $Tabs/Graphics/List/Fullscreen

onready var invert_mouse_toggle : CheckBox = $"Tabs/Gameplay/List/Invert Mouse"
onready var show_hud_toggle : CheckBox = $"Tabs/Gameplay/List/Show HUD"
onready var show_crosshair_toggle : CheckBox = $"Tabs/Gameplay/List/Show Crosshair"

onready var fast_graphics_toggle : CheckBox = $"Tabs/Graphics/List/Fast Graphics"
onready var screen_filter_toggle : CheckBox = $"Tabs/Graphics/List/Screen Filter"
onready var ambient_occlusion_toggle : CheckBox = $"Tabs/Graphics/List/Ambient Occlusion"

onready var fov_slider : HSlider = $"Tabs/Gameplay/List/FOV/Slider"
onready var fov_number = $"Tabs/Gameplay/List/FOV/Slider/Number"

onready var max_fps_slider : HSlider = $"Tabs/Graphics/List/Max FPS/Slider"
onready var max_fps_number = $"Tabs/Graphics/List/Max FPS/Slider/Number"

onready var resolution_scale_slider : HSlider = $"Tabs/Graphics/List/Resolution Scale/Slider"
onready var resolution_scale_number = $"Tabs/Graphics/List/Resolution Scale/Slider/Number"

onready var sfx_slider : HSlider = $"Tabs/Gameplay/List/SFX/Slider"
onready var music_slider : HSlider = $"Tabs/Gameplay/List/Music/Slider"
onready var master_slider : HSlider = $"Tabs/Gameplay/List/Master/Slider"

onready var mouse_sensitivity_slider : HSlider = $"Tabs/Gameplay/List/Mouse Sensitivity/Slider"

var camera : Camera
var game_viewport : Viewport
var environment : Environment
var pause_menu_buttons : VBoxContainer
var fps_label : Label
var level_name : String = "Main Menu"

var settings_closed_properly : bool = true

func _ready() -> void:
	SettingsData.load_settings()
	InputData.load_input_settings()
	
	self.set_visible(false)
	
	OS.set_min_window_size(Vector2(480, 270))
	
	if SettingsData.config_values.windowed_size_x == 0 and SettingsData.config_values.windowed_size_y == 0:
		OS.set_window_size(OS.get_screen_size())
	else:
		OS.set_window_size(Vector2(SettingsData.config_values.windowed_size_x, SettingsData.config_values.windowed_size_y))
	
	environment = load("res://Materials/Environment/Default Environment.res")
	level_name = LevelManager.get_current_level_name()

	game_viewport = get_node("/root/" + level_name + "/Viewport Container/Viewport")
	fps_label = get_node("/root/" + level_name + "/Debug/FPS")

	if level_name == "Main Menu":
		camera = get_node("/root/Main Menu/Viewport Container/Viewport/Level Scene/Camera")
	else:
		camera = get_node("/root/" + level_name + "/Viewport Container/Viewport/Player/Camera")
		pause_menu_buttons = get_node("/root/" + level_name + "/Interface/Pause Menu/Panel/Buttons")

	ErrorManager.check_errors(get_viewport().connect("size_changed", self, "_root_viewport_size_changed"))
	ErrorManager.check_errors(get_tree().get_current_scene().connect("ready", self, "_on_scene_root_node_ready"))
	ErrorManager.check_errors((connect("tree_exiting", self, "save_settings_safely")))
	
	OS.set_window_fullscreen(SettingsData.config_values.fullscreen)
	OS.set_use_vsync(SettingsData.config_values.v_sync)
	Engine.set_target_fps(SettingsData.config_values.max_fps)
	
	AudioServer.set_bus_volume_db(0, linear2db(SettingsData.config_values.get("master_volume")))
	AudioServer.set_bus_volume_db(2, linear2db(SettingsData.config_values.get("sfx_volume")))
	AudioServer.set_bus_volume_db(1, linear2db(SettingsData.config_values.get("music_volume")))

	if SettingsData.config_values.screen_filter == true:
		game_viewport.get_texture().set_flags(4)
	else:
		game_viewport.get_texture().set_flags(0)

	if SettingsData.config_values.msaa_4x == true:
		game_viewport.set_msaa(4)
	else:
		game_viewport.set_msaa(0)

	if SettingsData.config_values.ui_scaling == true:
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_EXPAND, Vector2(1920, 1080), 1.0)
	else:
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_DISABLED, SceneTree.STRETCH_ASPECT_IGNORE, Vector2(1920, 1080), 1.0)

	camera.set_fov(SettingsData.config_values.fov)
	environment.set_ssao_enabled(SettingsData.config_values.ambient_occlusion)
	v_sync_toggle.set_pressed(SettingsData.config_values.v_sync)
	show_fps_toggle.set_pressed(SettingsData.config_values.show_fps)
	ui_scaling_toggle.set_pressed(SettingsData.config_values.ui_scaling)
	msaa_4x_toggle.set_pressed(SettingsData.config_values.msaa_4x)
	fullscreen_toggle.set_pressed(SettingsData.config_values.fullscreen)
	invert_mouse_toggle.set_pressed(SettingsData.config_values.invert_mouse)
	show_hud_toggle.set_pressed(SettingsData.config_values.show_gameplay)
	show_crosshair_toggle.set_pressed(SettingsData.config_values.show_crosshair)
	fast_graphics_toggle.set_pressed(SettingsData.config_values.fast_graphics)
	screen_filter_toggle.set_pressed(SettingsData.config_values.screen_filter)
	ambient_occlusion_toggle.set_pressed(SettingsData.config_values.ambient_occlusion)

	fov_slider.set_value(SettingsData.config_values.fov)
	fov_number.set_text(str(SettingsData.config_values.fov))

	if SettingsData.config_values.max_fps == 241 or SettingsData.config_values.max_fps == 0:
		max_fps_slider.set_value(241)
		max_fps_number.set_text("No Limit")
	else:
		max_fps_slider.set_value(SettingsData.config_values.max_fps)
		max_fps_number.set_text(str(SettingsData.config_values.max_fps))

	resolution_scale_slider.set_value(SettingsData.config_values.resolution_scale)
	resolution_scale_number.set_text(str(SettingsData.config_values.resolution_scale * 100.0) + "%")

	sfx_slider.set_value(SettingsData.config_values.sfx_volume)
	music_slider.set_value(SettingsData.config_values.music_volume)
	master_slider.set_value(SettingsData.config_values.master_volume)

	mouse_sensitivity_slider.set_value(SettingsData.config_values.mouse_sensitivity)

func _on_Master_value_changed(value) -> void:
	AudioServer.set_bus_volume_db(0, linear2db(value))
	SettingsData.config_values.master_volume = value

func _on_Music_value_changed(value) -> void:
	AudioServer.set_bus_volume_db(1, linear2db(value))
	SettingsData.config_values.music_volume = value

func _on_SFX_value_changed(value) -> void:
	AudioServer.set_bus_volume_db(2, linear2db(value))
	SettingsData.config_values.sfx_volume = value

func _on_Ambient_Occlusion_toggled(button_pressed) -> void:
	environment.set_ssao_enabled(button_pressed)
	SettingsData.config_values.ambient_occlusion = button_pressed

func _on_Fast_Graphics_toggled(button_pressed) -> void:
	SettingsData.config_values.fast_graphics = button_pressed
	
func _on_Vsync_toggled(button_pressed) -> void:
	OS.set_use_vsync(button_pressed)
	SettingsData.config_values.v_sync = button_pressed

func _on_Max_FPS_value_changed(value) -> void:
	if value == 241:
		Engine.set_target_fps(0)
		max_fps_number.set_text("No Limit")
		SettingsData.config_values.max_fps = 0
	else:
		Engine.set_target_fps(value)
		max_fps_number.set_text(str(value))
		SettingsData.config_values.max_fps = value

func _on_Show_FPS_toggled(button_pressed) -> void:
	fps_label.set_visible(button_pressed)
	SettingsData.config_values.show_fps = button_pressed

func _on_FOV_value_changed(value) -> void:
	camera.set_fov(value)
	fov_number.set_text(str(value))
	SettingsData.config_values.fov = value

func _on_4X_MSAA_toggled(button_pressed) -> void:
	if button_pressed == true:
		game_viewport.set_msaa(4)
	else:
		game_viewport.set_msaa(0)
	SettingsData.config_values.msaa_4x = button_pressed

func _on_Fullscreen_toggled(button_pressed) -> void:
	OS.set_window_fullscreen(button_pressed)
	SettingsData.config_values.fullscreen = button_pressed

func _on_Resolution_Scale_value_changed(value) -> void:
	game_viewport.size = get_viewport().size * value
	resolution_scale_number.set_text(str(value * 100) + "%")
	SettingsData.config_values.resolution_scale = value

func _on_Screen_Filter_toggled(button_pressed) -> void:
	if button_pressed == true:
		game_viewport.get_texture().set_flags(4)
	else:
		game_viewport.get_texture().set_flags(0)

	SettingsData.config_values.screen_filter = button_pressed

func _on_UI_Scaling_toggled(button_pressed) -> void:
	if button_pressed == true:
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_EXPAND, Vector2(1920, 1080), 1.0)
	else:
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_DISABLED, SceneTree.STRETCH_ASPECT_IGNORE, Vector2(1920, 1080), 1.0)

	SettingsData.config_values.ui_scaling = button_pressed

func _root_viewport_size_changed() -> void:
	game_viewport.size = get_viewport().size * SettingsData.config_values.resolution_scale

func _on_scene_root_node_ready() -> void:
	game_viewport.size = get_viewport().size * SettingsData.config_values.resolution_scale

func _on_Mouse_Sensitivity_value_changed(value) -> void:
	SettingsData.config_values.mouse_sensitivity = value

func _on_Invert_Mouse_toggled(button_pressed) -> void:
	SettingsData.config_values.invert_mouse = button_pressed

func _on_Hide_HUD_toggled(button_pressed) -> void:
	SettingsData.config_values.show_gameplay = button_pressed

func _on_Hide_Crosshair_toggled(button_pressed) -> void:
	SettingsData.config_values.show_crosshair = button_pressed

func _on_Open_Settings_Button_pressed() -> void:
	if level_name != "Main Menu":
		self.set_visible(true)
		pause_menu_buttons.set_visible(false)
	else:
		self.set_visible(true)
		
	settings_closed_properly = false

func _on_Close_Settings_Button_pressed() -> void:
	self.set_visible(false)

	if level_name != "Main Menu":
		pause_menu_buttons.set_visible(true)
		PlayerStats.player.change_player_settings()

	save_settings()
	
	settings_closed_properly = true

func save_settings_safely() -> void:
	if settings_closed_properly == false or OS.get_window_size() != Vector2(SettingsData.config_values.windowed_size_x, SettingsData.config_values.windowed_size_y):
		save_settings()

func save_settings() -> void:
	SettingsData.config_values.windowed_size_x = OS.get_window_size().x
	SettingsData.config_values.windowed_size_y = OS.get_window_size().y

	SettingsData.save_settings()
	InputData.save_input_settings()
