extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var CalendarDays

# Called when the node enters the scene tree for the first time.
func _ready():
	CalendarDays = get_children()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_DirectorNode_progress_day(week):
	
	for day_index in range(7):
		var day := week[day_index] as Day
		var calendar_day := CalendarDays[day_index] as CalendarDay
		calendar_day.toggle_past(day.is_past)
	#wipe hours
	#set history
	#show summary
	#fade
	
	pass # Replace with function body.


func _on_DirectorNode_update_today(tasks, today_index):
	var today := CalendarDays[today_index] as CalendarDay
	today.update_today(tasks)
	pass # Replace with function body.
