## The menu that appears when you pause the game
class_name PauseMenu extends BaseUI

## The name of the scene that loads when quitting from the pause menu
var main_menu_scene: PackedScene = preload("uid://vstl3bg568s7")

## Controls the pause menu's animations
@onready var animator: AnimationPlayer = $animator
## The texture that blurs when the pause menu appears
@onready var background_blur: TextureRect = $background_blur
## Parent container of menu buttons list
@onready var margin_container: MarginContainer = $panel/margin_container
## Parent of the main pause menu buttons
@onready var menu_buttons: VBoxContainer = margin_container.get_node_or_null("menu_buttons")
## A confirmation warning that appears when quitting the game
@onready var quit_warning: Panel = margin_container.get_node_or_null("quit_warning")

## Only allow closing while an animation is not playing
var can_toggle: bool:
	get:
		return not animator.is_playing()

var last_mouse_mode: Input.MouseMode

func _ready() -> void:
	var viewport_texture: ViewportTexture = get_viewport().get_texture()
	background_blur.texture = ImageTexture.create_from_image(viewport_texture.get_image())

func open() -> void:
	if not can_toggle:
		return
	last_mouse_mode = Input.mouse_mode
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	show()
	pause()
	animator.play("open")
	
func close() -> void:
	if not can_toggle:
		return
	Input.mouse_mode = last_mouse_mode
	animator.play("close")
	_on_quit_warning_quit_canceled()

func toggle() -> void:
	if hidden:
		open()
	else:
		close()

## Pause or unpause the game
func pause(do_pause: bool = true) -> void:
	get_tree().set_pause(do_pause)

func _on_animator_animation_finished(anim_name: String) -> void:
	match anim_name:
		"close":
			pause(false)
			hide()

func _on_resume_button_pressed() -> void:
	close()

func _on_quit_button_pressed() -> void:
	menu_buttons.hide()
	quit_warning.show()

func _on_quit_warning_quit_confirmed() -> void:
	close()
	MinigameManager.level_timer.stop()
	SceneManager.change_scene(main_menu_scene)

func _on_quit_warning_quit_canceled() -> void:
	quit_warning.hide()
	menu_buttons.show()
