extends MinigameLevel

@export var code_str: String
@export var code: PackedStringArray

var code_file: FileAccess

@onready var code_lines: VBoxContainer = $margin_container/code_lines
@onready var terminal: Label = code_lines.get_node_or_null("terminal")

var line_index: int
var total_lines: int

func _ready() -> void:
	code_file = FileAccess.open("res://game/assets/text/code.txt", FileAccess.READ)
	while not code_file.eof_reached():
		code_file.get_line()
		total_lines += 1
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
		line_index += 1
		var amount: float = 4 * (float(line_index) / total_lines)
		cam_shaker.shake(amount, 0.125, true)
		if code_lines.get_child_count() > 28:
			code_lines.get_child(0).queue_free()
		if code_file.eof_reached():
			$anim.play("spin_in")
			win()
			MinigameManager.end_game()
