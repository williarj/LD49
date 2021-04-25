extends Node

class_name Todo

export(String) var short_description = ""
var long_description = ""
var tags_applied = []
var tags_required= []
var tags_incompatible = []
var current_incompatible_tags = []
var weight = 1
#var location = Globals.LocationEnum.PARK
export(float, 0.5, 24, 0.5) var hours_required := 1.5
var is_done := false
var is_possible := true

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
	
func can_be_done(tags_in_effect):
	current_incompatible_tags = []
	is_possible = true
	for tag in tags_in_effect:
		if tag in tags_incompatible:
			current_incompatible_tags.append(tag)
			is_possible = false

func pretty_tags():
	var tag_string = ""
	if current_incompatible_tags.size() > 0:
		for index in range(0, current_incompatible_tags.size()-1):
			var tag = current_incompatible_tags[index] 
			if !tag.begins_with("_"):
				tag_string += tag + ", "
	tag_string.trim_suffix(", ")
	return tag_string
		

func perform_task():
	return tags_applied
