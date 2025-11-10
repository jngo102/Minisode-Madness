class_name VolumeBarSegment extends Control

@onready var on_slot: ColorRect = $off_slot/on_slot

var on: bool:
	get:
		return on_slot.visible
	set(value):
		if value:
			on_slot.show()
		else:
			on_slot.hide()
