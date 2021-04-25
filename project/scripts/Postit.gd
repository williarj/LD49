extends VBoxContainer

signal task_toggled(checked_tasks)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
var TaskBoxes = []
func _ready():
	TaskBoxes = get_children()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_TaskBox_task_selected(my_index):
	var checked_tasks = []
	for index in range(TaskBoxes.size()):
		if (TaskBoxes[index] as TaskBox).is_checked():
			checked_tasks.append(index)
	
	emit_signal("task_toggled", checked_tasks)
	print(str(my_index) + " was selected")
	var my_box := TaskBoxes[my_index] as TaskBox
	#my_box.disable_box_toggle()
	pass # Replace with function body.



func _on_DirectorNode_update_task_list(tasks, total_task_count):
	# blank all tasks
	for TaskBox in TaskBoxes:
		(TaskBox as TaskBox).clear()
		# set text
		# set hours
		# set disable
	
	if total_task_count > 10:
		get_parent().get_node("PostIt").texture = load("res://assets/art/postit3.png")
	elif total_task_count > 5:
		get_parent().get_node("PostIt").texture = load("res://assets/art/postit2.png")
	else:
		get_parent().get_node("PostIt").texture = load("res://assets/art/postit1.png")
	
	#yeah, this is gross
	#this also still counts finished tasks that are in the queue
	get_parent().get_node("task_count_label").text = str(total_task_count)
	
	#loop through given tasks
	for task_index in range(tasks.size()):
		(TaskBoxes[task_index] as TaskBox).set_from_task(tasks[task_index])
	#	set text
	#	set possible
	#	set finished tasks visible stuff with a long ocmment
	pass # Replace with function body.

