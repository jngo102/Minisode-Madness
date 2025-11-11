## The game's main menu
class_name MainMenu extends Control

## Parent container of menu buttons list
@onready var _margin_container: MarginContainer = $margin_container
## List of all main menu buttons
@onready var _menu_buttons: WrappingVerticalList = _margin_container.get_node_or_null("menu_buttons")
## The button to quit the game
@onready var _quit_button: UIButton = _menu_buttons.get_node_or_null("quit_button")
## Warning for whether the player really wants to exit the game
@onready var _quit_warning: VBoxContainer = $quit_warning

var menu_music: MusicTrack = preload("uid://c0dxy53i8aplb")

func _ready() -> void:
	create_tween().tween_property(flowerwall_crt, "modulate", Color.WHITE, 1).from_current().set_trans(Tween.TRANS_LINEAR)
	AudioManager.play_music(menu_music, 0, 2)
	if OS.get_name() == "Web":
		_quit_button.hide()
	_menu_buttons.grab_focus()

func _on_start_button_pressed() -> void:
	#create_tween().tween_property(flowerwall_crt, "modulate", Color.TRANSPARENT, 1).from_current().set_trans(Tween.TRANS_LINEAR)
	MinigameManager.load_random_level()
	#SceneManager.change_scene(load("uid://b3neoogxgx3lr"))

func _on_options_button_pressed() -> void:
	pass # Replace with function body.

func _on_credits_button_pressed() -> void:
	pass # Replace with function body.

func _on_quit_button_pressed() -> void:
	_margin_container.hide()
	_quit_warning.show()

func _on_quit_warning_quit_canceled() -> void:
	_quit_warning.hide()
	_margin_container.show()

func _on_quit_warning_quit_confirmed() -> void:
	get_tree().quit()
