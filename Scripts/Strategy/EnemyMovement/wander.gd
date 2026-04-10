class_name Stategy_Wander
extends Strategy_Enemy_Movement

@export var wander_time: Timer
var change_directions: bool = true
var direction: Vector2

func _ready():
	pass
	
func enter():
	pass
	
func exit():
	pass

func update(_entity: Enemy_Entity, _delta: float):
	if change_directions:
		direction = Vector2(randf_range(-1,1), randf_range(-1,1))
		change_directions = false
		if wander_time.is_stopped():
			wander_time.start()
	var slow_entity: Status_Slow = null
	var speed: float = movement_component.movement_speed
	if movement_component.check_for_slow:
		slow_entity = _entity.status_effects.get_status_effect_by_name("slow_status")
	if slow_entity != null:
		speed *= (1-slow_entity.slow_effect)
	_entity.velocity = direction * speed

func enable_change_direction():
	change_directions = true

func _on_wander_time_timeout():
	enable_change_direction()
