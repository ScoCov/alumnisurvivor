class_name EnemyMovementMoveToPlayer
extends EnemyMovementStrategy


@onready var entity: Enemy_Entity = enemy_movement_component.enemy_entity

func update(_delta: float):
	if entity: ## Come back to add more logic
		entity.velocity = entity.position.direction_to(entity.player.position) * enemy_movement_component.movement_speed; 
