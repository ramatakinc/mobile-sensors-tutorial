extends MarginContainer

func _ready():
	connect("resized", self, "_update_safeArea")
	_update_safeArea()

func _update_safeArea():
	var view_size = get_viewport().size
	var rect_safe_area = OS.get_window_safe_area()
	add_constant_override("margin_right", view_size.x - rect_safe_area.end.x)
	add_constant_override("margin_bottom", view_size.y - rect_safe_area.end.y)
	add_constant_override("margin_left", rect_safe_area.position.x)
	add_constant_override("margin_top", rect_safe_area.position.y)
