extends ProgressBar

export var max_player_health : int = 100
var current_player_health : int

var label_color : String = "custom_colors/font_color"

export var label_path : NodePath
export var interface_path : NodePath
export var damage_animation_path : NodePath

onready var damage_animation : AnimationPlayer = get_node(damage_animation_path)
onready var interface : Control = get_node(interface_path)
onready var label : Label = get_node(label_path)
onready var style : StyleBoxFlat = get("custom_styles/fg")

func _ready() -> void:
	current_player_health = max_player_health
	label.set_text(str(current_player_health))
	style.set_bg_color(Color.green)
	label.set(label_color, Color.green)
	
	self.max_value = max_player_health
	self.value = max_player_health

func _on_ProgressBar_value_changed(value) -> void:
	label.set_text(str(value))

	if value >= 70:
		style.set_bg_color(Color.green)
		label.set(label_color, Color.green)
	if value >= 30 and value < 70:
		style.set_bg_color(Color.yellow)
		label.set(label_color, Color.yellow)
	if value > 0 and value < 30:
		style.set_bg_color(Color.red)
		label.set(label_color, Color.red)
	if value <= 0:
		label.set(label_color, Color.black)
		label.set_text("0")
		interface.show_death_panel()

func damage_player(value : int) -> void:
	if current_player_health > 0:
		current_player_health -= value
		
		if value > 0:
			damage_animation.play("damage")

	self.set_value(current_player_health)

func add_health(amount : int) -> void:
	if current_player_health + amount > max_player_health:
		current_player_health += max_player_health - current_player_health
	else:
		current_player_health += amount
	
	label.set_text(str(current_player_health))
	self.set_value(current_player_health)

func has_less_health() -> bool:
	return current_player_health < max_player_health

