extends Node
class_name Event

var event_tasks
var description
var notifications
var event_task_probability

func load_from_dict(dict):
	event_tasks = dict["tasks"]
	description = dict["description"]
	notifications = dict["notifications"]
	event_task_probability = dict["event_task_probability"]
	
func sample_task():
	var task_copy = null
	if (randf() < event_task_probability):
		var task = event_tasks[randi() % event_tasks.size()]
		task_copy = Todo.new()
		task_copy.load_from_todo(task)
	return task_copy
	
#something to pick tasks in a a weighted correct order?
