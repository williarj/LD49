extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var current_tags = []

# Called when the node enters the scene tree for the first time.
func _ready():
	display()
	pass # Replace with function body.

func add_tag(tag):
	if (!(tag in current_tags)):
		current_tags.append(tag)
		display()
	
func display():
	var new_text = "No effects yet."
	if (current_tags.size() > 0):
		new_text = str(current_tags[0])
		for index in range(1, current_tags.size()):
			new_text += ", "+current_tags[index]
		
	$tags.text = new_text

func clear_tags():
	current_tags = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


#this is really inefficient and loops a bunch of extra times
func add_tags(tags):
	for tag in tags:
		add_tag(tag)


#when the day rolls over clear out the old tags
func _on_DirectorNode_progress_day(day_index):
	clear_tags()
	display()


func _on_DirectorNode_update_today(tasks, today_index, tags):
	clear_tags()
	add_tags(tags)
