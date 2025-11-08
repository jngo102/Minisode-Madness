## Singleton containing miscellaneous constant values and helper functions
extends Node

## The default gravity value, in pixels per second squared
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

var SCREEN_WIDTH: int = 640
var SCREEN_HEIGHT: int = 480

## Get the closest object to a target
func get_closest(target: Node2D, objects: Array):
	var min_distance: float = INF
	var closest: Node2D = null
	for object in objects:
		var distance: float = object.global_position.distance_to(target.global_position)
		if distance <= min_distance:
			min_distance = distance
			closest = object
	return closest

## Get a random object from an array
func get_random(array: Array[Variant]) -> Variant:
	return array[randi_range(0, len(array) - 1)]

func random_position_on_screen() -> Vector2:
	return Vector2(randf_range(0, SCREEN_WIDTH), randf_range(0, SCREEN_HEIGHT))
