class_name MouseTracker extends Component

signal clicked

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		root.global_position = event.global_position
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		clicked.emit()
