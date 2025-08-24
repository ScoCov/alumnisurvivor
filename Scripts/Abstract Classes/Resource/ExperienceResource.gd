class_name ExperienceResource
extends Resource

@export var level: int = 1
## Increase growth of xp required to level. [log(xp_growth)]
@export var xp_growth: int = 100

@export var current_xp: float:
	set(value):
		current_xp = value
		if current_xp >= next_level_xp:
			current_xp -= next_level_xp
			level += 1

## Used purely for its' getter. This will return a log value using the xp_growth.
var next_level_xp: float:
	set(value): pass ## Do not let anyone set this value. It's caluclated.
	get: 
		return ceil(level * log(xp_growth))

func gain_xp(experience_gain: float) -> void:
	current_xp += experience_gain ## Add XP
