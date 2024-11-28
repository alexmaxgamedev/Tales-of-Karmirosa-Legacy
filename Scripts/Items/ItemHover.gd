extends Spatial

var timer : float
var hover : Vector3

func _process(delta) -> void:
	timer += delta

	if is_equal_approx(timer, 6.283):
		timer = 0.0

	hover.y = sin(timer * 3.0) / 2.0

	self.set_translation(hover)
	self.rotate_y(deg2rad(100.0 * delta))
