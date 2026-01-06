class_name Enemy_Movement_Component
extends Node

const MIN_SLOW_EFFECT: float = 0.05

@export var entity: Enemy_Entity

var movement_speed: float = 85
var speed_modifier: float = 1.0:
	set(value):
		if value < 0.05:
			value = 0.05
		speed_modifier = value
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

func _ready():
	var stats = get_children().filter(func(child): return child is EnemyMovementStrategy)
	movement_type = stats[0]

func _on_knockback_timer_timeout():
	is_knocked_backed = false

func knockback_effect(direction: Vector2, knockback_value: float):
	is_knocked_backed = true
	entity.velocity += direction * knockback_value
