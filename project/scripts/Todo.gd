extends Node

class_name Todo

export(String) var short_description = ""
var long_description = ""
var tags = []
var location = Globals.LocationEnum.PARK
export(float, 0.5, 24, 0.5) var hours_required := 1.5
var is_done := false

# Called when the node enters the scene tree for the first time.
func _ready():
	location = Globals.LocationEnum.GOVT_OFFICE

func can_be_done(today):
	pass

func perform_task():
	pass
