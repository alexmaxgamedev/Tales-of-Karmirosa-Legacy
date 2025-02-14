extends Control

export var outro_level_name : String

onready var death_panel_animation : AnimationPlayer= $"Death Panel/Animation"
onready var win_panel_animation : AnimationPlayer = $"Win Panel/Animation"

onready var gameplay : Control = $Gameplay
onready var crosshair : TextureRect = $Crosshair
onready var pause_menu  : Control = $"Pause Menu"
onready var death_panel : Control = $"Death Panel"
onready var settings_panel : Control = $"Pause Menu/Panel/Settings"
onready var pause_menu_buttons : VBoxContainer = $"Pause Menu/Panel/Buttons"

var is_paused : bool = false

func _exit_tree() -> void:
	get_tree().set_pause(false)

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	pause_menu.set_visible(false)
	death_panel.set_visible(false)
	settings_panel.set_visible(false)
	pause_menu_buttons.set_visible(true)
	
func _input(event) -> void:
	if event.is_action_pressed("pause"):
		is_paused = !is_paused
		set_pause_state(is_paused)

func set_pause_state(state : bool) -> void:
	pause_menu.set_visible(state)
	gameplay.set_visible(!state)
	crosshair.set_visible(!state)
	
	get_tree().set_pause(state)
	
	if state == true:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		PlayerStats.player.change_player_settings()
		PlayerStats.player.reset_walk_speed_fov()

func show_death_panel() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	death_panel_animation.play("appear")
	
	gameplay.set_visible(false)
	crosshair.set_visible(false)
	
	self.set_process_input(false)
	get_tree().set_pause(true)
	
func show_win_panel() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

	win_panel_animation.play("appear")

	gameplay.set_visible(false)
	crosshair.set_visible(false)
	
	self.set_process_input(false)
	get_tree().set_pause(true)

func _on_Resume_pressed() -> void:
	is_paused = false
	set_pause_state(false)

func _on_Restart_pressed() -> void:
	LevelManager.restart_current_level()

func load_outro() -> void:
	LevelManager.load_level(outro_level_name)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
