class_name Status_Slow
extends Status_Effect_Entity

## This variable will be how much, by percentage, to reduce movement speed by. Default is -10%,
## which will result in 90% movement speed.
@export var slow_effect: float = -0.1

func _ready():
	status_resource = load("res://Resources/Data/StatusEffects/slow_status.tres")
	update_duration(status_resource.duration)
	update_tick(status_resource.tick_rate)

func _on_expires():
	entity.movement_component.check_for_slow = false
	
func _on_initial_infection():
	entity.movement_component.check_for_slow = true
