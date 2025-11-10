class_name RedVox extends MinigameLevel

@export var music: MusicTrack
@export var lyrics: String

@onready var margin_container: MarginContainer = $margin_container
@onready var lyrics_container: VBoxContainer = margin_container.get_node_or_null("lyrics_container")

var lyrics_index: int = 0

var current_lyrics: HBoxContainer:
	get:
		return lyrics_container.get_child(lyrics_index)

var current_lyrics_width: int:
	get:
		var width: int = 0
		for child in current_lyrics.get_children():
			if child is Label:
				width += child.size.x
		return width

var lyric_sections: PackedStringArray = []
var words_to_type: PackedStringArray = []
var num_words_to_type: int = 3
var labels_to_type: Array[Label] = []
var label_index: int = 0
var currently_typed: String = ""

var current_label_to_type: Label:
	get:
		return labels_to_type[label_index]

var current_typed_label: Label:
	get:
		return current_label_to_type.get_child(0)

var text_to_type: String:
	get:
		return current_label_to_type.text

var typed_chars: String

func _ready() -> void:
	await super._ready()
	await get_tree().create_timer(1, false).timeout
	_start_game(music.music_clip.get_length())
	AudioManager.play_music(music)
	AudioManager.current_music_player.finished.connect(_on_player_finish)
	var lyric_words = lyrics.split(" ")
	for i in range(0, num_words_to_type):
		var word_index: int = randi() % (len(lyric_words) - 1)
		var lyric_word: String = lyric_words[word_index]
		while words_to_type.has(lyric_word):
			word_index = randi() % (len(lyric_words) - 1)
			lyric_word = lyric_words[word_index]
		words_to_type.append(lyric_word)
	for word in lyric_words:
		var word_label := Label.new()
		word_label.text = word
		if words_to_type.has(word):
			word_label.self_modulate = Color.TRANSPARENT
		
			var typed_label := Label.new()
			typed_label.text = ""
			typed_label.self_modulate = Color.GREEN
			
			labels_to_type.append(word_label)
			word_label.add_child(typed_label)
		
		_add_label(word_label)
	
	await get_tree().create_timer(3, false).timeout
	var fade_in_tween: Tween = create_tween()
	for label_to_type in labels_to_type:
		fade_in_tween.parallel().tween_property(label_to_type, "self_modulate", Color.YELLOW, 2).from_current().set_trans(Tween.TRANS_LINEAR)

func _input(event: InputEvent) -> void:
	if not started or finished:
		return
	if event is InputEventKey and event.is_pressed():
		var key_char: String = OS.get_keycode_string(event.keycode)
		if len(key_char) == 1:
			typed_chars += key_char.to_lower()
			current_typed_label.text = typed_chars
			var last_index: int = len(typed_chars) - 1
			var last_char: String = typed_chars[last_index]
			if typed_chars == text_to_type:
				typed_chars = ""
				label_index += 1
				if label_index >= len(labels_to_type):
					win()
			elif last_char != text_to_type[last_index]:
				lose()

func _add_label(new_label: Label) -> void:
	current_lyrics.add_child(new_label)
	var label_width: int = new_label.size.x
	if current_lyrics_width + 2 * label_width + margin_container.get_theme_constant("margin_left") + margin_container.get_theme_constant("margin_right") > Globals.SCREEN_WIDTH:
		current_lyrics.remove_child(new_label)
		var new_container := current_lyrics.duplicate()
		for child in new_container.get_children():
			child.free()
		lyrics_container.add_child(new_container)
		lyrics_index += 1
		current_lyrics.add_child(new_label)

func lose() -> void:
	current_typed_label.self_modulate = Color.RED
	super.lose()

func _on_player_finish() -> void:
	MinigameManager.play_game_music()
	if label_index < len(labels_to_type):
		lose()
