extends Node

class_name Day

var weather
var event
var mods := []
export (float, 0, 15, 0.5) var hours_available
var is_past = false

# Called when the node enters the scene tree for the first time.
func _ready():
	weather = Globals.WeatherEnum.values()[randi() % Globals.WeatherEnum.size()]
	pass # Replace with function body.

func add_mod(mod): 
	if mods.has(mod):
		return
	else:
		mods.append(mod) 

func remove_mod(mod):
	mods.erase(mod)
