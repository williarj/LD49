extends Node

class_name Todo

export(String) var short_description = ""
var long_description = ""
var tags_applied = []
var tags_required= []
var tags_incompatible = []
var weight = 1
#var location = Globals.LocationEnum.PARK
export(float, 0.5, 24, 0.5) var hours_required := 1.5
var is_done := false

func load_from_dict(dict):
	short_description = dict["short_description"]
	long_description = dict["long_description"]
	tags_applied = dict["tags_applied"]
	tags_required = dict["tags_required"]
	tags_incompatible = dict["tags_incompatible"]
	hours_required = dict["hours_required"]
	weight = dict["weight"]

func load_from_todo(todo : Todo):
	short_description = todo.short_description
	long_description = todo.long_description
	tags_applied = todo.tags_applied.duplicate()
	tags_required = todo.tags_required.duplicate()
	tags_incompatible = todo.tags_incompatible.duplicate()
	hours_required = todo.hours_required
	weight = todo.weight
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#location = Globals.LocationEnum.GOVT_OFFICE

func can_be_done(today):
	pass

func perform_task():
	return tags_applied
