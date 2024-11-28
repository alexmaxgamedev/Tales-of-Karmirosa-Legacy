extends Panel

onready var ui_element : CanvasItem = get_node("..")

func _ready() -> void:
	ErrorManager.check_errors(ui_element.connect("mouse_entered", self, "show_tooltip"))
	ErrorManager.check_errors(ui_element.connect("mouse_exited", self, "hide_tooltip"))

func show_tooltip() -> void:
	self.set_visible(true)

func hide_tooltip() -> void:
	self.set_visible(false)
