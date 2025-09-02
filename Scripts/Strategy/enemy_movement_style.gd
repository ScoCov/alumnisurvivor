class_name EnemyMovementStyle
extends Node

enum type {Move_to_Player, Circle_Player, Avoid_Player, Charge_Player, Maintain_Distance}

func update(enemy: EnemyEntity, _delta: float):
	pass


static func load_movement_type(_type: EnemyMovementStyle.type) -> EnemyMovementStyle:
	var load_movement: EnemyMovementStyle
	match _type:
		EnemyMovementStyle.type.Move_to_Player:
			load_movement = EnemyMovementToPlayer.new()
		EnemyMovementStyle.type.Avoid_Player:
			load_movement = EnemyMovementAvoidPlayer.new()
			
	return load_movement
