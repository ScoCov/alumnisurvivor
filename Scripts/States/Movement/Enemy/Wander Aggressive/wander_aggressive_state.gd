class_name Wander_Aggressive_State
extends Enemy_Wander_Movement_State

var target: Vector2


func update(_delta: float):
	if enemy_movement_component.is_knocked_backed or enemy_movement_component.movement_type is not EnemyMovementWanderAggressive:
		return
	var distance_to_player: float = entity.position.distance_to(entity.player.position)
	if distance_to_player > enemy_movement_component.movement_type.player_distance_limits.y:
		self.Transitioned.emit(self, "Wander_Aggressive_Too_Far")
	if distance_to_player < enemy_movement_component.movement_type.player_distance_limits.x:
		self.Transitioned.emit(self,"Wander_Aggressive_Chase")
 	## If there isn't a target or if there is a target and either: 
	## the entity has reached the target location, or the player has gotten 
	## considerably too far from the target.
	if ((target and (entity.position.distance_to(target) < 2 
	or entity.player.position.distance_to(target) > enemy_movement_component.movement_type.player_distance_limits.y)) 
	or not target):
		target = change_direction(entity.player.position)
	
	
	entity.velocity = entity.position.direction_to(target) * enemy_movement_component.speed

## Gives a Vector2 location for the entity to use to help determine directions.
## [target] == Seed Location
## [param] Dictionary {x:float, y:float} are  the range in which those directions
## will be applied to the [target] seed
func change_direction(_target: Vector2, param: Dictionary = {}) -> Vector2:
	var x_range_limit: int = param.x if param.has("x") else enemy_movement_component.movement_type.wander_precision.x
	var y_range_limit: int = param.y if param.has("y") else enemy_movement_component.movement_type.wander_precision.y
	return _target + Vector2(randf_range(-x_range_limit, x_range_limit)
								,randf_range(-y_range_limit, y_range_limit))
							
