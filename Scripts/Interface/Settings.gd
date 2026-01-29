extends Control

onready var fullscreen_toggle : CheckBox = $Tabs/Graphics/List/Fullscreen
onready var v_sync_toggle : CheckBox = $Tabs/Graphics/List/Vsync
onready var show_fps_toggle : CheckBox = $"Tabs/Graphics/List/Show FPS"
onready var vertex_lighting_toggle : CheckBox = $"Tabs/Graphics/List/Vertex Lighting"
onready var ambient_occlusion_toggle : CheckBox = $"Tabs/Graphics/List/Ambient Occlusion"
onready var ui_scaling_toggle : CheckBox = $"Tabs/Graphics/List/UI Scaling"
onready var msaa_toggle : CheckBox = $Tabs/Graphics/List/MSAA
onready var screen_filter_toggle : CheckBox = $"Tabs/Graphics/List/Screen Filter"
onready var resolution_scale_slider : HSlider = $"Tabs/Graphics/List/Resolution Scale/Slider"
onready var resolution_scale_number = $"Tabs/Graphics/List/Resolution Scale/Slider/Number"
onready var max_fps_slider : HSlider = $"Tabs/Graphics/List/Max FPS/Slider"
onready var max_fps_number = $"Tabs/Graphics/List/Max FPS/Slider/Number"
onready var sfx_slider : HSlider = $"Tabs/Gameplay/List/SFX/Slider"
onready var music_slider : HSlider = $"Tabs/Gameplay/List/Music/Slider"
onready var master_slider : HSlider = $"Tabs/Gameplay/List/Master/Slider"
onready var fov_slider : HSlider = $"Tabs/Gameplay/List/FOV/Slider"
onready var fov_number = $"Tabs/Gameplay/List/FOV/Slider/Number"
onready var mouse_sensitivity_slider : HSlider = $"Tabs/Gameplay/List/Mouse Sensitivity/Slider"
onready var invert_mouse_toggle : CheckBox = $"Tabs/Gameplay/List/Invert Mouse"
onready var show_hud_toggle : CheckBox = $"Tabs/Gameplay/List/Show HUD"
onready var show_crosshair_toggle : CheckBox = $"Tabs/Gameplay/List/Show Crosshair"

var camera : Camera
var game_viewport : Viewport
var pause_menu_buttons : VBoxContainer
var fps_label : Label

var level_name : String = "Menu"

var environment : Environment
var default_mat : Material
var glass_mat : Material

func _enter_tree():
	SettingsData.load_settings()

func _ready() -> void:
	OS.set_min_window_size(Vector2(480, 270))

	if SettingsData.config_values.windowed_size_x == 0 and SettingsData.config_values.windowed_size_y == 0:
		OS.set_window_size(OS.get_screen_size())
	else:
		OS.set_window_size(Vector2(SettingsData.config_values.windowed_size_x, SettingsData.config_values.windowed_size_y))

	load_materials()

	level_name = LevelManager.get_current_level_name()
	game_viewport = get_node("/root/" + level_name + "/Screen/Viewport")
	fps_label = get_node("/root/" + level_name + "/Debug/FPS")

	if level_name == "Menu":
		camera = get_node("/root/Menu/Screen/Viewport/Level Scene/Camera")
	else:
		camera = get_node("/root/" + level_name + "/Screen/Viewport/Player/Camera")
		pause_menu_buttons = get_node("/root/" + level_name + "/Interface/Pause Menu/Panel/Buttons")

	ErrorManager.check_errors(get_viewport().connect("size_changed", self, "_root_viewport_size_changed"))
	ErrorManager.check_errors(get_tree().get_current_scene().connect("ready", self, "_on_scene_root_node_ready"))

	set_values()
	update_elements()
	connect_signals()

func load_materials() -> void:
	environment = load("res://Materials/Environment/Default.res")
	default_mat = load("res://Materials/Environment/Environment.material")
	glass_mat = load("res://Materials/Environment/Glass.material")

func change_fullscreen(button_pressed) -> void:
	OS.set_window_fullscreen(button_pressed)
	SettingsData.config_values.fullscreen = button_pressed

func change_vsync(button_pressed) -> void:
	OS.set_use_vsync(button_pressed)
	SettingsData.config_values.v_sync = button_pressed

func change_fps_visibility(button_pressed) -> void:
	fps_label.set_visible(button_pressed)
	SettingsData.config_values.show_fps = button_pressed

func change_vertex_lighting(button_pressed) -> void:
	default_mat.flags_vertex_lighting = button_pressed
	glass_mat.flags_vertex_lighting = button_pressed

	SettingsData.config_values.vertex_lighting = button_pressed

func change_ambient_occlusion(button_pressed) -> void:
	environment.set_ssao_enabled(button_pressed)
	SettingsData.config_values.ambient_occlusion = button_pressed

func change_ui_scaling(button_pressed) -> void:
	if button_pressed == true:
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_EXPAND, Vector2(1920, 1080), 1.0)
	else:
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_DISABLED, SceneTree.STRETCH_ASPECT_IGNORE, Vector2(1920, 1080), 1.0)

	SettingsData.config_values.ui_scaling = button_pressed

func change_fxaa(button_pressed) -> void:
	game_viewport.set_use_fxaa(button_pressed)
	SettingsData.config_values.fxaa = button_pressed

func change_msaa(button_pressed) -> void:
	if button_pressed == true:
		game_viewport.set_msaa(4)
	else:
		game_viewport.set_msaa(0)

	SettingsData.config_values.msaa = button_pressed

func change_screen_filter(button_pressed) -> void:
	if button_pressed == true:
		game_viewport.get_texture().set_flags(4)
	else:
		game_viewport.get_texture().set_flags(0)

	SettingsData.config_values.screen_filter = button_pressed

func change_resolution_scale(value) -> void:
	game_viewport.size = get_viewport().size * value
	resolution_scale_number.set_text(str(value * 100) + "%")
	SettingsData.config_values.resolution_scale = value

func change_max_fps(value) -> void:
	if value == 241:
		Engine.set_target_fps(0)
		max_fps_number.set_text("No Limit")
	else:
		Engine.set_target_fps(value)
		max_fps_number.set_text(str(value))

	SettingsData.config_values.max_fps = value

func change_master_volume(value) -> void:
	AudioServer.set_bus_volume_db(0, linear2db(value))
	SettingsData.config_values.master_volume = value

func change_music_volume(value) -> void:
	AudioServer.set_bus_volume_db(1, linear2db(value))
	SettingsData.config_values.music_volume = value

func change_sfx_volume(value) -> void:
	AudioServer.set_bus_volume_db(2, linear2db(value))
	SettingsData.config_values.sfx_volume = value

func change_fov(value) -> void:
	camera.set_fov(value)
	fov_number.set_text(str(value))
	SettingsData.config_values.fov = value

func change_mouse_sensitivity(value) -> void:
	SettingsData.config_values.mouse_sensitivity = value

func change_mouse_inversion(button_pressed) -> void:
	SettingsData.config_values.invert_mouse = button_pressed

func change_hud_visibility(button_pressed) -> void:
	SettingsData.config_values.show_gameplay = button_pressed

func change_crosshair_visibility(button_pressed) -> void:
	SettingsData.config_values.show_crosshair = button_pressed

func set_values() -> void:
	change_fullscreen(SettingsData.config_values.fullscreen)
	change_vsync(SettingsData.config_values.v_sync)
	change_fps_visibility(SettingsData.config_values.show_fps)
	change_vertex_lighting(SettingsData.config_values.vertex_lighting)
	change_ambient_occlusion(SettingsData.config_values.ambient_occlusion)
	change_ui_scaling(SettingsData.config_values.ui_scaling)
	change_msaa(SettingsData.config_values.msaa)
	change_screen_filter(SettingsData.config_values.screen_filter)
	change_resolution_scale(SettingsData.config_values.resolution_scale)
	change_max_fps(SettingsData.config_values.max_fps)
	change_master_volume(SettingsData.config_values.master_volume)
	change_music_volume(SettingsData.config_values.music_volume)
	change_sfx_volume(SettingsData.config_values.sfx_volume)
	change_fov(SettingsData.config_values.fov)
	change_mouse_sensitivity(SettingsData.config_values.mouse_sensitivity)
	change_mouse_inversion(SettingsData.config_values.invert_mouse)
	change_hud_visibility(SettingsData.config_values.show_gameplay)
	change_crosshair_visibility(SettingsData.config_values.show_crosshair)

func update_elements() -> void:
	fullscreen_toggle.set_pressed(SettingsData.config_values.fullscreen)
	v_sync_toggle.set_pressed(SettingsData.config_values.v_sync)
	show_fps_toggle.set_pressed(SettingsData.config_values.show_fps)
	vertex_lighting_toggle.set_pressed(SettingsData.config_values.vertex_lighting)
	ambient_occlusion_toggle.set_pressed(SettingsData.config_values.ambient_occlusion)
	ui_scaling_toggle.set_pressed(SettingsData.config_values.ui_scaling)
	msaa_toggle.set_pressed(SettingsData.config_values.msaa)
	screen_filter_toggle.set_pressed(SettingsData.config_values.screen_filter)
	resolution_scale_slider.set_value(SettingsData.config_values.resolution_scale)
	max_fps_slider.set_value(SettingsData.config_values.max_fps)
	master_slider.set_value(SettingsData.config_values.master_volume)
	music_slider.set_value(SettingsData.config_values.music_volume)
	sfx_slider.set_value(SettingsData.config_values.sfx_volume)
	fov_slider.set_value(SettingsData.config_values.fov)
	mouse_sensitivity_slider.set_value(SettingsData.config_values.mouse_sensitivity)
	invert_mouse_toggle.set_pressed(SettingsData.config_values.invert_mouse)
	show_hud_toggle.set_pressed(SettingsData.config_values.show_gameplay)
	show_crosshair_toggle.set_pressed(SettingsData.config_values.show_crosshair)

func connect_signals() -> void:
	ErrorManager.check_errors(fullscreen_toggle.connect("toggled", self, "change_fullscreen"))
	ErrorManager.check_errors(v_sync_toggle.connect("toggled", self, "change_vsync"))
	ErrorManager.check_errors(show_fps_toggle.connect("toggled", self, "change_fps_visibility"))
	ErrorManager.check_errors(vertex_lighting_toggle.connect("toggled", self, "change_vertex_lighting"))
	ErrorManager.check_errors(ambient_occlusion_toggle.connect("toggled", self, "change_ambient_occlusion"))
	ErrorManager.check_errors(ui_scaling_toggle.connect("toggled", self, "change_ui_scaling"))
	ErrorManager.check_errors(msaa_toggle.connect("toggled", self, "change_msaa"))
	ErrorManager.check_errors(screen_filter_toggle.connect("toggled", self, "change_screen_filter"))
	ErrorManager.check_errors(resolution_scale_slider.connect("value_changed", self, "change_resolution_scale"))
	ErrorManager.check_errors(max_fps_slider.connect("value_changed", self, "change_max_fps"))
	ErrorManager.check_errors(master_slider.connect("value_changed", self, "change_master_volume"))
	ErrorManager.check_errors(music_slider.connect("value_changed", self, "change_music_volume"))
	ErrorManager.check_errors(sfx_slider.connect("value_changed", self, "change_sfx_volume"))
	ErrorManager.check_errors(fov_slider.connect("value_changed", self, "change_fov"))
	ErrorManager.check_errors(mouse_sensitivity_slider.connect("value_changed", self, "change_mouse_sensitivity"))
	ErrorManager.check_errors(invert_mouse_toggle.connect("toggled", self, "change_mouse_inversion"))
	ErrorManager.check_errors(show_hud_toggle.connect("toggled", self, "change_hud_visibility"))
	ErrorManager.check_errors(show_crosshair_toggle.connect("toggled", self, "change_crosshair_visibility"))

func _root_viewport_size_changed() -> void:
	game_viewport.size = get_viewport().size * SettingsData.config_values.resolution_scale

func _on_scene_root_node_ready() -> void:
	game_viewport.size = get_viewport().size * SettingsData.config_values.resolution_scale

func _on_Open_Settings_Button_pressed() -> void:
	self.set_visible(true)

	if level_name != "Menu":
		pause_menu_buttons.set_visible(false)

func _on_Close_Settings_Button_pressed() -> void:
	self.set_visible(false)

	if level_name != "Menu":
		pause_menu_buttons.set_visible(true)

	save_settings()

func save_settings() -> void:
	SettingsData.config_values.windowed_size_x = OS.get_window_size().x
	SettingsData.config_values.windowed_size_y = OS.get_window_size().y
	SettingsData.save_settings()

func _exit_tree():
	save_settings()
