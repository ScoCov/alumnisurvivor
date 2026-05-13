class_name Difficulty
extends Resource

const BASE_SPAWN_MOD: float = 1.00
const BASE_HEALTH_MOD: float = 1.00
const BASE_DAMAGE_MOD: float = 1.00

enum MODE {NORMAL, DIFFICULT, HARD, VERY_HARD, IMPOSSIBLE, LEGENDARY}

##Select the current Difficulty Mode
@export var current_mode: MODE = MODE.NORMAL

## Spawn Mod, is the multiplier that will be applied to the number of spawns the
## given stage will initialize. 
var spawn_mod: float:
	get():
		return _add_to_multiplier(BASE_SPAWN_MOD)
var health_mod: float:
	get():
		return _add_to_multiplier(BASE_HEALTH_MOD)
		
var damage_mod: float:
	get():
		return _add_to_multiplier(BASE_DAMAGE_MOD)

func _to_string():
	var _string: String = "Difficulty: "
	match current_mode:
		MODE.NORMAL:
			_string += "Normal"
		MODE.DIFFICULT:
			_string += "Difficult"
		MODE.HARD:
			_string += "Hard"
		MODE.VERY_HARD: 
			_string += "Very-Hard"
		MODE.IMPOSSIBLE:
			_string += "Impossible"
		MODE.LEGENDARY:
			_string += "Legendary"
	return _string

func _add_to_multiplier(base_value: float) -> float:
		var _inc: float = base_value
		match current_mode:
			MODE.NORMAL:
				_inc += 0.0 #1.0x
			MODE.DIFFICULT:
				_inc += 0.2 #1.2x
			MODE.HARD:
				_inc += 0.5 #1.5x
			MODE.VERY_HARD: 
				_inc += 1.00 #2x
			MODE.IMPOSSIBLE:
				_inc += 2.00 #3x
			MODE.LEGENDARY:
				_inc += 4.00 ## 5x
		return _inc
	
