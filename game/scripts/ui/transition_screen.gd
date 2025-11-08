class_name TransitionScreen extends BaseUI
## Displays when transitioning between screens

@onready var video_player: VideoStreamPlayer = $video_player

## Emitted when the screen finishes transitioning in
signal transitioned

func open() -> void:
	super.open()
	video_player.play()

func _on_video_player_finished() -> void:
	transitioned.emit()
