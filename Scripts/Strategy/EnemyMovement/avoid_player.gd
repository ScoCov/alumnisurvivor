class_name Stategy_Avoid_Player
extends Strategy_Enemy_Movement

@export var entity: Enemy_Entity
@export var min_distance: float = 150
@export var max_distance: float = 150
@export var manual_timer: Timer


@onready var player: Player_Entity = entity.player
@onready var signed_direction: int = _options[randi_range(0,1)]

var manual_override: bool = false

var _options: Array[int] = [1,-1]

func _process(_delta):
	pass

func enter():
	pass
	
func exit():
	pass

func update(_entity: Enemy_Entity, _delta: float):
	## Unused rotating vector
	## x` = x*cos(angle) - y*sin(angle)
	## y` = x*sin(angle) + y*cos(angle)
	var _direction = _entity.position.direction_to(player.position)
	var distance: float = _entity.position.distance_to(player.position)
	var speed: float = movement_component.movement_speed
	
	if distance <= min_distance:
		_direction = direction_control(direction.Move_Away, _direction)
	elif distance >= max_distance:
		_direction = direction_control(direction.Move_To, _direction)
	else: 
		_direction = direction_control(direction.Circle, _direction, 
			distance, signed_direction)
		speed *= 0.75

	$"../../Direction Arrow".rotation = _direction.angle()
	movement_component.direction = _direction
	var slow_entity: Status_Slow = null
	if movement_component.check_for_slow:
		slow_entity = _entity.status_effects.get_status_effect_by_name("slow_status")
	if slow_entity != null:
		speed *= (1-slow_entity.slow_effect)
	_entity.velocity = movement_component.direction * speed

enum direction {Move_To, Move_Away, Circle}
func direction_control(dir: direction, _direction, distance = null, signed = null) -> Vector2:
	if manual_override:
		if manual_timer.is_stopped():
			manual_timer.start()
		return signed_direction * _direction
	match dir:
		direction.Move_Away:
			return -_direction
		direction.Circle:
			if entity.velocity == Vector2.ZERO:
				manual_override = true
			return _direction.rotated(distance / (distance /max_distance )) * signed
	return _direction
	
func _on_manual_override_timeout():
	manual_override = false
