extends Node
class_name Event

var event_tasks
var description
var notifications
var event_task_probability
var unused_notifications

func reset_event():
	unused_notifications = notifications.duplicate()
	unused_notifications.shuffle()

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

func sample_notification():
	var note = null
	if (randf() < 0.7 and unused_notifications.size() > 0):
		note = unused_notifications.pop_back()
	return note

#something to pick tasks in a a weighted correct order?
