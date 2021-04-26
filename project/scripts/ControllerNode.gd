extends Node

signal update_today(tasks, today_index, tags)
signal progress_day(day_index)
signal update_task_list(visible_tasks, total_task_count)
signal push_notification(text)
signal add_tags_today(tags)
signal game_ended(game_ender, task_count)

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

var permanent_tags = []

var shuffled_tasks = []


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
	add_random_tasks(3)
	
	#make_tasks()
	
	emit_signal("progress_day", Days.slice(get_week_start(), get_week_start()+7))
	emit_signal("update_task_list", get_visible_tasks(), Tasks.size())
	
	pass # Replace with function body.

func add_random_tasks(n=1):
	var task_copy
	var tasks_added = 0
	
	#chance of sampling one event task each day
	if (current_event != null):
		task_copy = current_event.sample_task()
		if task_copy != null and task_can_spawn(task_copy):
			n -= 1
			tasks_added += 1
			Tasks.append(task_copy)
			print(Tasks[-1].short_description)
			
	#sample standard tasks
	var task_bag = get_task_bag_for_today()
	
	for i in range(n):
		if task_bag.size() < 1:
			break
		#var task = possible_tasks[randi() % possible_tasks.size()]
		task_copy = Todo.new()
		task_copy.load_from_todo(task_bag.pop_back())
		tasks_added += 1
		Tasks.append(task_copy)
	
	return tasks_added

func get_task_bag_for_today():	
	var possible_tasks_today = possible_tasks.duplicate()
			
	var todays_tags = get_tags_for_today()
	#remove tasks for which there is a tag that prevents spawning
	for task in possible_tasks:
		if !task_can_spawn(task):
			possible_tasks_today.erase(task)
		
	var weighted_tasks_today = weight_tasks(possible_tasks_today)
	weighted_tasks_today.shuffle()
	return weighted_tasks_today

func task_can_spawn(task):
	var todays_tags = get_tags_for_today()
	for tag in todays_tags:
		if task.tags_that_prevent.has(tag):
			return false
	for tag_prereq in task.tags_prereq:
		if !todays_tags.has(tag_prereq):
			return false
	for existing_task in Tasks:
		if !existing_task.is_done and existing_task.orig_id == task.orig_id:
			return false
	return true
	

func weight_tasks(tasks):
	weighted_tasks = []
	for task in tasks:
		task = task as Todo
		for i in range(ceil(task.weight)):
			weighted_tasks.append(task)
	return weighted_tasks

func get_tags_for_today():
	var todays_tags = (Days[TodayIndex] as Day).get_tags()
	todays_tags += permanent_tags
	todays_tags += [Globals.weather_enum_to_tag(Days[TodayIndex].weather)]
	return todays_tags

func sample_approx_poisson():
	#assumes lambda = 2, capped at 5
	var num = 0
	for i in range(5):
		if randf() < 0.5:
			num += 1
		else:
			break
	return num

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
	if (TodayIndex > event_start_day and current_event == null):
		#events will be active for 10-20 days, then change
		#event_start_day = rand_range(TodayIndex+10, TodayIndex+20)
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
		var tags_to_apply = task.perform_task()
		
		for tag in tags_to_apply.keys():
			var duration = tags_to_apply[tag]
			if duration < 0:
				if !permanent_tags.has(tag):
					permanent_tags.append(tag)
			else:
				for i in range(tags_to_apply[tag]):
					get_future_day(i).add_tag(tag)
		# mark tasks as complete
		task.is_done = true
		
	for task in assigned_tasks:
		task = task as Todo
		for tag in task.tags_consumed:
			permanent_tags.erase(tag)
			get_future_day(0).remove_tag(tag)
		
	
	tags_from_yesterday = get_tags_for_today()
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
	
	#send some notifications to the phone about world events
	if current_event != null:
		var note = current_event.sample_notification()
		if note != null:
			emit_signal("push_notification", note)
	
	var n_added = add_random_tasks(new_task_count)
	if n_added > 0:
		emit_signal("push_notification", "%s new tasks were added." % [n_added])
	
	# send signal for visible page of tasks
	emit_signal("update_task_list", get_visible_tasks(), Tasks.size())
	
	emit_signal("update_today", [], TodayIndex % 7, [])
	
	var todays_tags = get_tags_for_today()
	if current_event != null:
		for game_ender in current_event.game_enders:
			if game_ender in todays_tags:
				print("game ended: " + str(game_ender))
				emit_signal("game_ended", game_ender, Tasks.size())
	if "dead" in todays_tags or "_dead" in todays_tags:
		print("game ended: dead")
		emit_signal("game_ended", "dead", Tasks.size())

func get_week_start():
	return int(floor(TodayIndex / 7)*7)

func get_visible_tasks():
	var first_visible_task = int(floor((Tasks.size()-1) / 5) * 5)
	var visible_tasks = Tasks.slice(first_visible_task, Tasks.size()-1)
	
	#check if each task is possible today
	for task in visible_tasks:
		task.can_be_done(get_tags_for_today())
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

func get_future_day(n):
	while (TodayIndex + n) >= Days.size():
		make_week()
	return Days[TodayIndex + n]

func _on_VBoxContainer_task_toggled(checked_indexes):
	var visible_tasks = get_visible_tasks()
	
	assigned_tasks.clear()
	
	var additional_tags = []
	for checked_index in checked_indexes:
		assigned_tasks.append(visible_tasks[checked_index])
		additional_tags += (visible_tasks[checked_index] as Todo).tags_applied.keys()
	
	var tomorrow_tags = get_future_day(1).get_tags() + additional_tags
		
	emit_signal("update_today", assigned_tasks, TodayIndex % 7, tomorrow_tags)
	pass # Replace with function body.


func _on_ExitButton_pressed():
	get_tree().change_scene("res://scenes/splash.tscn")
