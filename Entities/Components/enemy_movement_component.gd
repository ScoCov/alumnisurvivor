class_name Enemy_Movement_Component
extends Node

const MIN_SLOW_EFFECT: float = 0.05
const MAX_SLOW_EFFECT: float = 3
const MIN_STACK_MULT: float = 1
const MAX_STACK_MULT: float = 2

@export var entity: Enemy_Entity

var movement_speed: float = 85
var speed_modifier: float = 1.0:
	set(value):
		speed_modifier = clamp(value, MIN_SLOW_EFFECT, MAX_SLOW_EFFECT)
	get:
		var value = 0
		if check_for_slow:
			var slow_res: Status_Effect_Resource = load("res://Resources/Data/StatusEffects/slow_status.tres")
			var status_effect = get_parent().status_effects.get_status_effect(slow_res)
			if status_effect:
				value += status_effect.status_resource.base_value * status_effect.stack_count
		return speed_modifier + value
		
var is_knocked_backed: bool = false:
	set(value):
		if value and $KnockbackTimer.is_stopped():
			$KnockbackTimer.start() 
		is_knocked_backed = value
		
var speed: float:
	set(value):
		pass
	get:
		return movement_speed * speed_modifier
		
var movement_type: EnemyMovementStrategy
var check_for_slow: bool = false

func _ready():
	var stats = get_children().filter(func(child): return child is EnemyMovementStrategy)
	movement_type = stats[0]

func _on_knockback_timer_timeout():
	is_knocked_backed = false

func knockback_effect(direction: Vector2, knockback_value: float):
	is_knocked_backed = true
	entity.velocity += direction * knockback_value
