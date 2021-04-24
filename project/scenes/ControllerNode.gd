extends Node

signal update_today(tasks, today_index)
signal progress_day(day_index)
signal update_task_list(visible_tasks, total_task_count)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var TodayIndex
var Days = []
var Tasks = []
var assigned_tasks = []

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	TodayIndex = 0
	make_week()
	make_week()
	make_week()
	
	make_tasks()
	
	emit_signal("progress_day", Days.slice(get_week_start(), get_week_start()+7))
	emit_signal("update_task_list", get_visible_tasks(), Tasks.size())
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_StartWorkButton_pressed():
	Days[TodayIndex].is_past = true
	TodayIndex += 1
	emit_signal("progress_day", Days.slice(get_week_start(), get_week_start()+7))
	
	# loop through selected tasks
	for task in assigned_tasks:
		task = task as Todo
		
		# have each of those tasks take effect
		task.perform_task()
		# mark tasks as complete
		task.is_done = true
		
	assigned_tasks.clear()
	
	var all_done := true
	for visible_task in get_visible_tasks():
		all_done = all_done and visible_task.is_done
	
	if all_done:
		for visible_task in get_visible_tasks():
			Tasks.erase(visible_task)
	
	
	# send signal for visible page of tasks
	emit_signal("update_task_list", get_visible_tasks(), Tasks.size())
	
	emit_signal("update_today", [], TodayIndex)
	pass # Replace with function body.

func get_week_start():
	return int(floor(TodayIndex / 7)*7)

func get_visible_tasks():
	var first_visible_task = int(floor((Tasks.size()-1) / 5) * 5)
	return Tasks.slice(first_visible_task, first_visible_task+5)

func make_week():
	for i in range(7):
		Days.append(Day.new())

func make_tasks():
	for i in range(13):
		Tasks.append(Todo.new())

func _on_VBoxContainer_task_toggled(checked_indexes):
	var visible_tasks = get_visible_tasks()
	
	assigned_tasks.clear()
	
	for checked_index in checked_indexes:
		assigned_tasks.append(visible_tasks[checked_index])
		
	emit_signal("update_today", assigned_tasks, TodayIndex)
	pass # Replace with function body.
