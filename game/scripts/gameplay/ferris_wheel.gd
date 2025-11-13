class_name FerrisWheel extends Node2D

@export var unhinge_angular_velocity: float = 10

@onready var body: RigidBody2D = $body
@onready var grab_collision: CollisionShape2D = body.get_node_or_null("grab_area/collision")
@onready var pin: PinJoint2D = $pin

signal unhinge

var spin_clip: AudioStream = preload("uid://0bmrhf4qp6gd")
var unhinge_clip: AudioStream = preload("uid://ldn376enbdy3")
var roll_clip: AudioStream = preload("uid://bdvrascrotyis")

var max_grab_radius: float
var can_grab: bool
var is_grabbing: bool
var _grab_offset: Vector2
var _unhinged: bool
var _unhinge_spin_speed: float

var _unhinge_velocity_y: float
var spinning_player: AudioStreamPlayer2D
var _roll_player: AudioStreamPlayer2D

func _ready() -> void:
	if grab_collision.shape is CircleShape2D:
		max_grab_radius = grab_collision.shape.radius

#func _process(delta: float) -> void:
	#if _unhinged:
		#body.rotate(unhinge_angular_velocity * delta)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed() and can_grab and not is_grabbing:
			_grab(event)
		elif not event.is_pressed() and is_grabbing:
			is_grabbing = false
			if not is_instance_valid(spinning_player):
				spinning_player.stop()
	elif is_grabbing and event is InputEventMouseMotion:
		_spin(event)

func _exit_tree() -> void:
	if is_instance_valid(_roll_player):
		_roll_player.queue_free()
	stop_spin_sound()

func _grab(event: InputEventMouseButton) -> void:
	is_grabbing = true
	_grab_offset = event.global_position - global_position

func _spin(event: InputEventMouseMotion) -> void:
	var offset: Vector2 = event.global_position - body.global_position
	var grab_angle: float = atan2(offset.y, offset.x)
	var grab_radius: float = min(max_grab_radius, (event.global_position - body.global_position).length())
	var normalized_grab_offset: Vector2 = offset.normalized()
	var grab_offset: Vector2 = normalized_grab_offset * grab_radius
	var force_vector: Vector2 = event.relative * min(grab_radius, offset.length())
	body.apply_force(force_vector, grab_offset)
	if not is_instance_valid(spinning_player):
		spinning_player = AudioManager.play_clip(spin_clip)
	if not _unhinged and body.angular_velocity > unhinge_angular_velocity:
		_unhinge()

func stop_spin_sound() -> void:
	if is_instance_valid(spinning_player):
		spinning_player.stop()
		spinning_player.queue_free()

func _unhinge() -> void:
	grab_collision.disabled = true
	is_grabbing = false
	body.add_constant_central_force(Vector2.RIGHT * body.angular_velocity * 2 * PI * max_grab_radius)
	pin.queue_free()
	_unhinged = true
	unhinge.emit()
	stop_spin_sound
	AudioManager.play_clip(unhinge_clip)
	_roll_player = AudioManager.play_clip(roll_clip, 1, 1, 0.9)
	_unhinge_spin_speed = -body.angular_velocity * 2 * PI * max_grab_radius

func _on_grab_area_area_entered(area: Area2D) -> void:
	can_grab = true

func _on_grab_area_area_exited(area: Area2D) -> void:
	can_grab = false
