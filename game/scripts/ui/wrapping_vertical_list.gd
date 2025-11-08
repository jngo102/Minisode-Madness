## Vertical list whose contents wrap around
class_name WrappingVerticalList extends VBoxContainer

func _ready() -> void:
	set_focus_mode(FOCUS_ALL)
	var first_child: Control = get_child(0)
	var last_child: Control = get_child(get_child_count() - 1)
	first_child.focus_neighbor_top = last_child.get_path()
	last_child.focus_neighbor_bottom = first_child.get_path()
	focus_entered.connect(first_child.grab_focus)
	
	for i in get_child_count():
		var element: Control = get_child(i)
		var child_count: int = get_child_count()
		element.focus_neighbor_bottom = get_child((i + 1) % child_count).get_path()
		element.focus_neighbor_top = get_child(((i - 1) + child_count) % child_count).get_path()
