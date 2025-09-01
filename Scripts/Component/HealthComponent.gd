extends Component
class_name HealthComponent

const health_attribute = preload("res://Resources/Data/Attributes/Health.tres")

signal dead # <= 0% health
signal near_dead # <25% Health
signal very_hurt # > 25% < 75%
signal hurt # > 50% < 75% health
signal barely_hurt # > 75% < 100%
signal unharmed # == 100% health
signal over_healed # > 100% health

var current_health: float
			
			
var max_health: float: 
	set(health):
		base_value = health if not 0.0 else 1.0
	get:
		return base_value + mod_value

func _init():
	if !attribute:
		attribute = health_attribute

func _ready():
	current_health = base_value

## Call this function when entity takes damage
func take_damage(damage_value: float):
	if current_health - damage_value <= 0:
		return null ## If dead, simply exit, no need to calculate data.
	current_health -= damage_value
