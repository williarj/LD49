extends Node

class_name Day

var weather
var event
var mods := []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_mod(mod : ModsEnum):
	if mods.has(mod):
		return
	else:
		mods.append(mod)

func remove_mod(mod : ModsEnum):
	mods.erase(mod)
