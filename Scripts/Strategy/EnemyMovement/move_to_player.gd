class_name EnemyMovementMoveToPlayer
extends EnemyMovementStrategy


@onready var entity: Enemy_Entity = enemy_movement_component.enemy_entity

func update(_delta: float):
	if entity and not enemy_movement_component.is_knocked_backed:
		var direction = entity.position.direction_to(entity.player.position)
		entity.velocity = (direction * enemy_movement_component.speed) 
