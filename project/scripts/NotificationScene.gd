extends TextureRect
class_name Notification

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = 3.0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func startTimer():
	visible = true
	$Timer.start()

func _on_Timer_timeout():
	$Timer.stop()
	fade_out()
	pass # Replace with function body.

func set_notification(text):
	$NotificationText.text = text
	startTimer()

#starts the fade out
func fade_out():
	$Tween.interpolate_property(self, "modulate", ColorN("white", 1), ColorN("white", 0), 1.0)
	$Tween.start()

#when the fade is done this should kill the notification
func _on_Tween_tween_all_completed():
	queue_free()
