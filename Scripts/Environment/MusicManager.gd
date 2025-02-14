extends AudioStreamPlayer

var level_songs : Array = []
var custom_songs : Array = []

var new_song_index : int = 0
var current_song_index : int = 0

var can_be_played : bool = true
var is_in_looped_mode : bool = true

func _init():
	level_songs.push_back(preload("res://Audio/Music/game_music_1.ogg"))
	level_songs.push_back(preload("res://Audio/Music/game_music_2.ogg"))
	level_songs.push_back(preload("res://Audio/Music/game_music_3.ogg"))
	
	custom_songs.push_back(preload("res://Audio/Music/boss_battle_music.ogg"))

func _ready() -> void:
	ErrorManager.check_errors(self.connect("finished", self, "_on_song_finished_playing"))
	
	if level_songs.size() > 0:
		play_looped_audio()

func play_looped_audio() -> void:
	is_in_looped_mode = true
	
	self.set_stream(level_songs[0])
	self.play()

func stop_all_audio() -> void:
	self.stop()

func play_custom_music(song_index : int) -> void:
	if song_index < 0 or song_index > custom_songs.size() - 1:
		return
	
	is_in_looped_mode = true

	self.set_stream(custom_songs[song_index])
	self.play()

func _on_song_finished_playing() -> void:
	if is_in_looped_mode == true:
		if level_songs.size() > 1:
			while(new_song_index == current_song_index):
				new_song_index = int(rand_range(0, level_songs.size()))
				
			current_song_index = new_song_index
			
			self.set_stream(level_songs[current_song_index])
			self.play()
