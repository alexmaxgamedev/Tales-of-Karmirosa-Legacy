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
var can_be_paused : bool = true

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
	if event.is_action_pressed("pause") and can_be_paused:
		is_paused = !is_paused
		set_pause_state(is_paused)

func set_pause_state(state : bool) -> void:
	if state == true:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		pause_menu.set_visible(state)
		gameplay.set_visible(!state)
		crosshair.set_visible(!state)
		
		get_tree().set_pause(state)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
		pause_menu.set_visible(state)
		gameplay.set_visible(!state)
		crosshair.set_visible(!state)
		settings_panel.set_visible(state)
		pause_menu_buttons.set_visible(!state)
		
		settings_panel.save_settings_safely()
		PlayerStats.player.change_player_settings()
		
		get_tree().set_pause(state)

func show_death_panel() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	death_panel_animation.play("appear")
	is_paused = true
	gameplay.set_visible(false)
	crosshair.set_visible(false)
	can_be_paused = false
	get_tree().set_pause(is_paused)
	
func show_win_panel() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	win_panel_animation.play("appear")
	is_paused = true
	gameplay.set_visible(false)
	crosshair.set_visible(false)
	can_be_paused = false
	get_tree().set_pause(is_paused)

func _on_Resume_pressed() -> void:
	is_paused = false
	set_pause_state(false)

func _on_Restart_pressed() -> void:
	LevelManager.restart_current_level()

func load_outro() -> void:
	LevelManager.load_level(outro_level_name)
