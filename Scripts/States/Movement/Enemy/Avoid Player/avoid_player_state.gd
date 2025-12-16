class_name Avoid_Player_State
extends Enemy_Avoid_Player_Movement_State

## I don't know how to get it to choose randomly between -1,1 without this
const binary_array = [-1,1]
## This will apply a clockwise[1] or counter clockwise[-1] behavior.
var direction_tendency: int = 1

func enter():
	direction_tendency = binary_array[randi_range(0, len(binary_array) - 1)]

func update(_delta: float):
	if enemy_movement_component.is_knocked_backed or enemy_movement_component.movement_type is not EnemyMovementAvoidPlayer:
		return

	## Determine distance from player:
	var enemy_entity = enemy_movement_component.enemy_entity
	var distance = enemy_entity.position.distance_to(enemy_entity.player.position)
	
	if distance < enemy_movement_component.movement_type.player_distance_limits.x:
		self.Transitioned.emit(self,"Avoid_Player_Too_Close")
	elif distance > enemy_movement_component.movement_type.player_distance_limits.y:
		self.Transitioned.emit(self,"Avoid_Player_Too_Far")
	 
	var direction = enemy_entity.position.direction_to(enemy_entity.player.position).rotated(PI/2)
	enemy_entity.velocity = (direction_tendency * direction) * (enemy_movement_component.movement_speed * 0.20)
	
