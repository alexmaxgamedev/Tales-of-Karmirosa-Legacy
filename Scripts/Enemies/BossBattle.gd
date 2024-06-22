extends Area

export var level_music_manager_path : NodePath
onready var level_music_manager = get_node(level_music_manager_path)

export var key_spawn_point_path : NodePath
onready var key_spawn_point = get_node(key_spawn_point_path)

var killed_boss_count = 0
var player_entered = false

func increase_killed_boss_count():
	killed_boss_count += 1
	
	if killed_boss_count == 6:
		spawn_key("purple", Color("7523b8"))

func spawn_key(type : String, color : Color):
		var key_prefab = load("res://Prefabs/Pickups/Key.tscn")
		var key_prefab_instance = key_prefab.instance()
		
		key_spawn_point.add_child(key_prefab_instance)
		
		key_prefab_instance.change_color(color)
		key_prefab_instance.type = type

func _on_Boss_Battle_body_entered(body):
	if body.is_in_group("Player") and player_entered == false:
		level_music_manager.stop_all_audio()
		level_music_manager.play_custom_music(0)
		
		player_entered = true
