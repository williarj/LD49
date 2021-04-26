extends Node

class_name Day

var weather
var event
var tags := []
export (float, 0, 15, 0.5) var hours_available
var is_past = false

# Called when the node enters the scene tree for the first time.
func _init():
	weather = Globals.WeatherEnum.values()[randi() % Globals.WeatherEnum.size()]

func add_tag(tag): 
	if tags.has(tag):
		pass
	else:
		tags.append(tag) 

func remove_tag(tag):
	tags.erase(tag)

func get_tags():
	return tags.duplicate()
