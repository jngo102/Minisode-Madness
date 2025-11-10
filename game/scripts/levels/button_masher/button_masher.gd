extends MinigameLevel

@onready var typed_letters: Label = $typed_letters

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		typed_letters.text += event.as_text()
