class_name EnemyMovementMoveToPlayer
extends EnemyMovementStrategy

func enter():
	pass
	
func exit():
	pass

func update(entity: Enemy_Entity, player: Student_Entity, _delta: float):
	_move_toward_player(entity,player,_delta)

func _move_toward_player(entity: Enemy_Entity, player: Student_Entity,_delta: float):
	if entity.movement_component.is_knocked_backed: return ## Exit early if is being knocked back.
	var direction = entity.position.direction_to(player.position)
	if entity.entity.looks_at_target:
		entity.sprite_2d.look_at(entity.player.position)
	entity.velocity = direction * entity.movement_component.speed
