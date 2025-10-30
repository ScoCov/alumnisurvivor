class_name EnemyMovementStrategy
extends Node

enum type {Move_to_Player, Circle_Player, Avoid_Player, Charge_Player, Maintain_Distance}

func update(enemy: EnemyEntity, _delta: float):
	pass

static func load_movement_type(_type: EnemyMovementStrategy.type) -> EnemyMovementStrategy:
	var load_movement: EnemyMovementStrategy
	match _type:
		EnemyMovementStrategy.type.Move_to_Player:
			load_movement = EnemyMovementStrategy.new()
		EnemyMovementStrategy.type.Avoid_Player:
			load_movement = EnemyMovementStrategy.new()
			
	return load_movement
