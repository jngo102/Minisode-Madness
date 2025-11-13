extends Control

var show_skip: bool

var main_menu_scene: PackedScene = preload("uid://vstl3bg568s7")

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if not show_skip:
			show_skip = true
			$skip.show()
		else:
			SceneManager.change_scene_fade(main_menu_scene, 0.25, 2)
