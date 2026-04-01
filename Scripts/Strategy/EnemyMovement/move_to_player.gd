class_name Strategy_Move_to_Player
extends Strategy_Enemy_Movement



func enter():
	pass
	
func exit():
	pass

func update(_entity: Enemy_Entity, _delta: float):
	var direction_to_player:= _entity.position.direction_to(_entity.player.position)
	var slow_entity: Status_Slow = null
	var speed: float = movement_component.movement_speed
	if movement_component.check_for_slow:
		slow_entity = _entity.status_effects.get_status_effect_by_name("slow_status")
	if slow_entity != null:
		speed *= (1-slow_entity.slow_effect)
	_entity.velocity = direction_to_player * speed
