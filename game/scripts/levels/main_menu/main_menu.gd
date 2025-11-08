## The game's main menu
class_name MainMenu extends Control

## Parent container of menu buttons list
@onready var _margin_container: MarginContainer = $margin_container
## List of all main menu buttons
@onready var _menu_buttons: WrappingVerticalList = _margin_container.get_node_or_null("menu_buttons")
## The button to quit the game
@onready var _quit_button: Button = _menu_buttons.get_node_or_null("quit_button")
## Warning for whether the player really wants to exit the game
@onready var _quit_warning: VBoxContainer = $quit_warning

func _ready() -> void:
	AudioManager.stop_music()
	if OS.get_name() == "Web":
		_quit_button.hide()
	_menu_buttons.grab_focus()

func _on_start_button_pressed() -> void:
	MinigameManager.load_random_level()

func _on_quit_button_pressed() -> void:
	_margin_container.hide()
	_quit_warning.show()

func _on_quit_warning_quit_canceled() -> void:
	_quit_warning.hide()
	_margin_container.show()

func _on_quit_warning_quit_confirmed() -> void:
	get_tree().quit()
