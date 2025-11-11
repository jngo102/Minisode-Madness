extends MinigameLevel

@export var code_str: String
@export var code: PackedStringArray

var code_file: FileAccess

@onready var code_lines: VBoxContainer = $margin_container/code_lines
@onready var terminal: Label = code_lines.get_node_or_null("terminal")

var lines: PackedStringArray

func _ready() -> void:
	code_file = FileAccess.open("res://game/assets/text/code.txt", FileAccess.READ)
	await super._ready()
	_start_game(16)
	while code_lines.get_child_count() <= 1:
		if is_instance_valid(terminal):
			terminal.text = "hacker@hacknet: ~$"
			await get_tree().create_timer(0.5, false).timeout
		if is_instance_valid(terminal):
			terminal.text = "hacker@hacknet: ~$ _"
			await get_tree().create_timer(0.5, false).timeout

func _input(event: InputEvent) -> void:
	if not started or finished:
		return
	if event is InputEventKey:
		var new_label := Label.new()
		new_label.text = code_file.get_line()
		var code_settings := LabelSettings.new()
		code_settings.font_size = 24
		new_label.label_settings = code_settings
		code_lines.add_child(new_label)
		if code_lines.get_child_count() > 28:
			code_lines.get_child(0).queue_free()
		if code_file.eof_reached():
			win()
			MinigameManager.end_game()
