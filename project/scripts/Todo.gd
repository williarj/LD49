extends Node

class_name Todo

var short_description
var long_description
var tags
var location
var hours_required : float
var is_done : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	location = LocationEnum.GOVT_OFFICE

func can_be_done(today):
	pass

func perform_task(today, tomorrow):
	pass
