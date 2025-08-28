extends Component
class_name HealthComponent

const health_attribute = preload("res://Resources/Data/Attributes/Health.tres")

signal low_health
signal zero_health
signal full_health

var current_health: float 
var max_health: float: 
	set(health):
		base_value = health if not 0.0 else 1.0
	get:
		return base_value

func _init():
	if !attribute:
		attribute = health_attribute

func _ready():
	current_health = base_value

## Call this function when entity takes damage
func take_damage(damage_value: float):
	if current_health - damage_value <= 0:
		zero_health.emit()
		return null ## If dead, simply exit, no need to calculate data.
		
	current_health -= damage_value
	if max_health / current_health < 0.33:
		low_health.emit()
