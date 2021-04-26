extends TextureRect
class_name CalendarDay

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var day_name = "DAYDAY"

# Called when the node enters the scene tree for the first time.
func _ready():
	$DayLabel.text = day_name
	$MemoLabel.text = ""
	pass # Replace with function body.

func set_day_name(text : String):
	$DayLabel.text = text
	
func set_weather(weather): 
	match weather:
		Globals.WeatherEnum.RAIN: 
			$WeatherSprite.texture = load("res://assets/art/weather/rain.png")
		Globals.WeatherEnum.CLOUD:
			$WeatherSprite.texture = load("res://assets/art/weather/cloudy.png")
		Globals.WeatherEnum.WIND:
			$WeatherSprite.texture = load("res://assets/art/weather/wind.png")
		Globals.WeatherEnum.SNOW:
			$WeatherSprite.texture = load("res://assets/art/weather/snow.png")
		Globals.WeatherEnum.SUN:
			$WeatherSprite.texture = load("res://assets/art/weather/sun.png")
		_:
			$WeatherSprite.texture = load("res://assets/art/weather/sun.png")
			

func set_memo(text : String):
	$MemoLabel.text = text

func set_time_allocation(text : String):
	$MemoLabel.text = text + " hrs"

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func toggle_past(is_past : bool):
	if is_past:
		self.modulate = ColorN("gray")
	else:
		self.modulate = ColorN("white")

func update_today(tasks):
	var total_time = 0
	var total_memo = ""
	for task in tasks:
		task = (task as Todo)
		total_memo += task.short_description
		total_time += task.hours_required
	set_memo(total_memo)
	set_time_allocation(str(total_time))
	pass # Replace with function body.

func reset():
	$MemoLabel.text = ""
