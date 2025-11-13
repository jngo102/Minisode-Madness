## Manages game audio and music
extends Node

## The volume in decibels at which audio is not perceived
var audio_off_db: float = ProjectSettings.get_setting("audio/buses/channel_disable_threshold_db")

## The prefab to instantiate when playing a one shot clip
@export var audio_player_prefab: PackedScene

## Parent of all spawned generic audio players
@onready var audio_players: Node = $audio_players
## Parent of all spawned music players
@onready var music_players: Node = $music_players
## The audio stream player of the current music track, fades out to upcoming music player
@onready var current_music_player: AudioStreamPlayer2D = music_players.get_node("current_music_player")
## The audio stream player of the current music track, fades in from current music player
@onready var upcoming_music_player: AudioStreamPlayer2D = music_players.get_node("upcoming_music_player")

## The currently playing music track
var current_track: MusicTrack

## The currently running tween for adjusting volume fade between music tracks
var volume_tween: Tween

## Music volume combined with master volume
var music_volume: float:
	get:
		return remap(SaveManager.settings.master_volume * SaveManager.settings.music_volume, 0.0, 1.0, audio_off_db, 0)
	
## SFX volume combined with master volume
var sfx_volume_scale: float:
	get:
		return SaveManager.settings.master_volume * SaveManager.settings.sfx_volume

func _ready() -> void:
	update_music_volume()
	
## Play a one shot audio clip
func play_clip(clip: AudioStream, pitch_min: float = 1, pitch_max: float = 1, volume_scale: float = 1.0) -> AudioStreamPlayer2D:
	var audio_player: AudioStreamPlayer2D = audio_player_prefab.instantiate()
	audio_player.volume_db = remap(volume_scale * sfx_volume_scale, 0.0, 1.0, audio_off_db, 0.0)
	audio_player.pitch_scale = randf_range(pitch_min, pitch_max)
	audio_player.finished.connect(func(): audio_player.queue_free())
	audio_player.stream = clip
	audio_players.add_child(audio_player)
	audio_player.play()
	return audio_player

## Play a music track, fading out from the current track into the new track
func play_music(track: MusicTrack, start_time: float = 0, fade_time: float = 0.5, immediate: bool = false) -> void:
	if volume_tween and volume_tween.is_running():
		volume_tween.custom_step(INF)
		volume_tween.kill()
	# Immediately play music if nothing is currently playing (or if immediate specified)
	current_track = track
	if immediate:
		current_music_player.stop()
		current_music_player.set_stream(track.music_clip)
		current_music_player.play(start_time)
		return
	# Don't fade in and out of the same music track
	elif current_music_player.stream and track.music_clip.resource_path == current_music_player.stream.resource_path:
		return
	upcoming_music_player.set_stream(track.music_clip)
	volume_tween = create_tween()
	volume_tween.finished.connect(on_volume_tween_finished)
	upcoming_music_player.play(start_time)
	volume_tween.tween_property(current_music_player, "volume_db", audio_off_db, fade_time) \
		.from_current() \
		.set_trans(Tween.TRANS_EXPO)
	volume_tween.parallel().tween_property(upcoming_music_player, "volume_db", music_volume, fade_time) \
		.from(audio_off_db) \
		.set_trans(Tween.TRANS_EXPO)

## Stop the currently playing music
func stop_music() -> void:
	current_music_player.stop()
	current_music_player.stream = null
	upcoming_music_player.stop()
	upcoming_music_player.stream = null
	current_track = null

## Update the current music volume
func update_music_volume() -> void:
	current_music_player.volume_db = music_volume

## Callback for when the volume tween finishes
func on_volume_tween_finished() -> void:
	current_music_player.set_stream(current_track.music_clip)
	current_music_player.play(upcoming_music_player.get_playback_position())
	current_music_player.set_volume_db(music_volume)
	upcoming_music_player.stop()
