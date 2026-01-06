class_name Wander_Ignore_Too_Far
extends Enemy_Wander_Movement_State

var target: Vector2

func update(_delta: float):
	if enemy_movement_component.is_knocked_backed: return
	if entity.position.distance_to(entity.player.position)  < enemy_movement_component.movement_type.player_distance_limits.y:
		self.Transitioned.emit(self, "Wander_Ignore_State")
	## If there is no target, or if there is a target and either, the entity has
	## reached the target location or the player is still too far from the
	## entity, assign a new target.
	if ((target and (entity.position.distance_to(target) < 2 
		or entity.position.distance_to(entity.player.position) > enemy_movement_component.movement_type.player_distance_limits.y))
		or not target):
		target = change_direction(entity.player.position, {"x": enemy_movement_component.movement_type.redirection_precision.x, "y": enemy_movement_component.movement_type.redirection_precision.y})
	if (entity.enemy as EnemyResource).looks_at_target:
		entity.look_at(target)
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
							
