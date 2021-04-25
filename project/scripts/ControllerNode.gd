extends Node

signal update_today(tasks, today_index, tags)
signal progress_day(day_index)
signal update_task_list(visible_tasks, total_task_count)
signal push_notification(text)
signal add_tags_today(tags)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var TodayIndex
var Days = []
var Tasks = []
var weighted_tasks = []
var assigned_tasks = []
var possible_tasks = []
var possible_events = []


var current_event : Event = null
var event_start_day = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	TodayIndex = 0
	make_week()
	make_week()
	make_week()
	
	possible_tasks = load_tasks()
	weighted_tasks = weight_tasks(possible_tasks)
	possible_events = load_events()
	add_random_tasks(13)
	
	#make_tasks()
	
	emit_signal("progress_day", Days.slice(get_week_start(), get_week_start()+7))
	emit_signal("update_task_list", get_visible_tasks(), Tasks.size())
	
	pass # Replace with function body.

var shuffled_tasks = []
func add_random_tasks(n=1):
	var task_copy 
	#chance of sampling one event task each day
	if (current_event != null):
		task_copy = current_event.sample_task()
		if task_copy != null:
			n -= 1
			Tasks.append(task_copy)
			print(Tasks[-1].short_description)
	
	#sample standard tasks
	for i in range(n):
		if (shuffled_tasks.size() < 1):
			order_tasks()
		#var task = possible_tasks[randi() % possible_tasks.size()]
		task_copy = Todo.new()
		task_copy.load_from_todo(shuffled_tasks.pop_back())
		Tasks.append(task_copy)

func order_tasks():
	shuffled_tasks = weighted_tasks.duplicate()
	shuffled_tasks.shuffle()
	
func weight_tasks(tasks):
	weighted_tasks = []
	for task in tasks:
		task = task as Todo
		for i in range(ceil(task.weight)):
			weighted_tasks.append(task)
	return weighted_tasks

func sample_approx_poisson():
	#assumes lambda = 2, capped at 5
	var rand = randf()
	if rand < 0.135:
		return 0 
	elif rand < 0.405:
		return 1
	elif rand < 0.65:
		return 2
	elif rand < 0.855:
		return 3
	elif rand < 0.945:
		return 4
	else:
		return 5

func load_tasks():
	var file = File.new()
	file.open("res://data/task_data.json", file.READ)
	var text = file.get_as_text()
	var tasks_dict = JSON.parse(text).result
	
	return(task_dicts_to_array(tasks_dict))

func task_dicts_to_array(tasks_dict):
	var tasks = []
	for task_data in tasks_dict:
		var new_task = Todo.new()
		new_task.load_from_dict(task_data)
		tasks.append(new_task)
	return tasks
	
func load_events():
	var file = File.new()
	file.open("res://data/event_data.json", file.READ)
	var text = file.get_as_text()
	var events_dict = JSON.parse(text).result
	
	var events = []
	for event_data in events_dict:
		var new_event = Event.new()
		event_data["tasks"] = task_dicts_to_array(event_data["tasks"])
		new_event.load_from_dict(event_data)
		events.append(new_event)
	
	return(events)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func check_event():
	if (TodayIndex > event_start_day || current_event == null):
		#events will be active for 10-20 days, then change
		event_start_day = rand_range(TodayIndex+10, TodayIndex+20)
		current_event = possible_events[randi() % possible_events.size()]
		current_event.reset_event()
		print(current_event.description)
		

func remove_duplicates(arr):
	var dict = {}
	for item in arr:
		dict[item] = 1
	return dict.keys()

var tags_from_yesterday = []
#var dumb_tags = ["apple", "bottom", "pears", "apple", "cat", "apple", "car"]
func _on_StartWorkButton_pressed():
	#set up the day info
	Days[TodayIndex].is_past = true
	TodayIndex += 1
	
	#add another week if we reach the end of the array
	if TodayIndex >= Days.size():
		make_week()
	
	emit_signal("progress_day", Days.slice(get_week_start(), get_week_start()+6))
	
	#emit_signal("add_tag_today", dumb_tags[TodayIndex])
	
	#deal with done tasks
	tags_from_yesterday = []#TODO: THIS BREAKS MULTI DAY THINGS?
	# loop through selected tasks
	for task in assigned_tasks:
		task = task as Todo
		
		# have each of those tasks take effect
		tags_from_yesterday += task.perform_task()
		# mark tasks as complete
		task.is_done = true
	
	tags_from_yesterday = remove_duplicates(tags_from_yesterday)
	emit_signal("add_tags_today", tags_from_yesterday)
		
	assigned_tasks.clear()
	
	var all_done := true
	for visible_task in get_visible_tasks():
		all_done = all_done and visible_task.is_done
	
	if all_done:
		for visible_task in get_visible_tasks():
			Tasks.erase(visible_task)
	
	#update event info
	check_event()
	
	#sample new tasks for the day
	var new_task_count = sample_approx_poisson()
	emit_signal("push_notification", "%s new tasks were added." % [new_task_count])
	
	#send some notifications to the phone about world events
	if current_event != null:
		var note = current_event.sample_notification()
		if note != null:
			emit_signal("push_notification", note)
	
	
	add_random_tasks(new_task_count)
	
	# send signal for visible page of tasks
	emit_signal("update_task_list", get_visible_tasks(), Tasks.size())
	
	emit_signal("update_today", [], TodayIndex % 7, [])
	pass # Replace with function body.

func get_week_start():
	return int(floor(TodayIndex / 7)*7)

func get_visible_tasks():
	var first_visible_task = int(floor((Tasks.size()-1) / 5) * 5)
	var visible_tasks = Tasks.slice(first_visible_task, Tasks.size()-1)
	
	#check if each task is possible today
	for task in visible_tasks:
		task.can_be_done(tags_from_yesterday+[Globals.weather_enum_to_tag(Days[TodayIndex].weather)])
#		task.is_possible = true
#		for tag in tags_from_yesterday:
#			if tag in task.tags_incompatible:
#				task.is_possible = false
#				break
#		if Days[TodayIndex].weather != null and Globals.weather_enum_to_tag(Days[TodayIndex].weather) in task.tags_incompatible:
#			task.is_possible = false
	
	return visible_tasks


func make_week():
	for i in range(7):
		Days.append(Day.new())

func make_tasks():
	for i in range(13):
		Tasks.append(Todo.new())


func _on_VBoxContainer_task_toggled(checked_indexes):
	var visible_tasks = get_visible_tasks()
	
	assigned_tasks.clear()
	
	var applied_tags = []
	for checked_index in checked_indexes:
		assigned_tasks.append(visible_tasks[checked_index])
		applied_tags += (visible_tasks[checked_index] as Todo).tags_applied
		
	emit_signal("update_today", assigned_tasks, TodayIndex % 7, applied_tags)
	pass # Replace with function body.
