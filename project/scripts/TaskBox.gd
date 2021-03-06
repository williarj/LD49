extends HBoxContainer
class_name TaskBox 

export var task_index : int
signal task_selected(my_index)

var is_complete := false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_task_complete(complete : bool):
	#this should be called when the task was done on a previous day
	$CheckBox.pressed = complete
	$CheckBox.disabled = complete
	$line.visible = complete
	is_complete = complete

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func is_checked():
	return $CheckBox.pressed and !is_complete

func _on_CheckBox_toggled(button_pressed):
	emit_signal("task_selected", task_index)
	pass # Replace with function body.
	

func set_from_task(task : Todo):
	$TaskName.text = task.short_description# + " " + str(task.get_instance_id())
	hint_tooltip = task.long_description
	$TaskTime.text = str(task.hours_required) + " hrs."
	set_task_complete(task.is_done)
	visible = true
	#UI indication you cant click this
	
	$CheckBox.disabled = !task.is_possible
	$disabled_box.visible = false
	if !task.is_possible and !task.is_done:
		$disabled_box.visible = true
		hint_tooltip += "\n***This task is not possible today because of one of these:\n" + str(task.pretty_tags())
	
func clear():
	$TaskName.text = ""
	hint_tooltip = ""
	$TaskTime.text = ""
	set_task_complete(false)
	$CheckBox.pressed = false
	visible = false
	


func _on_CheckBox_pressed():
	emit_signal("task_selected", task_index)
	pass # Replace with function body.
