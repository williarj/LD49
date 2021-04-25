extends VBoxContainer
class_name Phone

# Called when the node enters the scene tree for the first time.
var notification_boxes
var pending_notifications = []
var max_notifications = 4
var notification_scene = preload("res://scenes/NotificationScene.tscn")
func _ready():
	pass
	
func push_notification(text):
	pending_notifications.push_back(text)

func _process(delta):
	if get_children().size() < max_notifications and pending_notifications.size() > 0:
		var new_notification = notification_scene.instance()
		add_child(new_notification)
		(new_notification as Notification).set_notification(pending_notifications.pop_front())

