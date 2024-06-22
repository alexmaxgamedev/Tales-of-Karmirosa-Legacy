extends Label

var fps : float
var label_color : String = "custom_colors/font_color"

func _ready():
	self.set_visible(SettingsData.config_values.show_fps)

func _process(_delta) -> void:
	fps = Engine.get_frames_per_second()
	self.set_text(str(fps))

	if fps >= 40.0:
		self.set(label_color, Color.green)
	if fps >= 20.0 and fps < 60.0:
		self.set(label_color, Color.yellow)
	if fps >= 0.0 and fps < 20.0:
		self.set(label_color, Color.red)
