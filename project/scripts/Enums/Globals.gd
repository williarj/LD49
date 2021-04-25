class_name Globals
extends Reference


enum WeatherEnum {
	SUN,
	RAIN,
	WIND,
	CLOUD,
	SNOW,
}

static func weather_enum_to_tag(enum_item):
	var tags = ["sun","rain","wind","cloud","snow"]
	return tags[enum_item]

#Unused atm
enum LocationEnum {
	GOVT_OFFICE,
	GROCERY_STORE,
	HARDWARE_STORE,
	PARK
}

enum ModsEnum {
	BANK_HOLIDAY,
	WEEKEND,
	WORK_HOLIDAY
}

enum TagsEnum {
	PHYSICAL,
	MENTAL,
	INDOOR_ONLY,
	OUTDOOR_ONLY,
	EMERGENCY,
	REQUIRES_DRIVING,
	WALKABLE
}

