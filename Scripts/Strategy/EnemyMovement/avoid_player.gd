class_name EnemyMovementAvoidPlayer
extends EnemyMovementStrategy

@export var too_close_distance: float = 150
@export var too_far_distance: float = 250
var angle = 0
var target = Vector2.ZERO
var desired_distance = (too_close_distance + too_far_distance) / 2

func update(entity: Enemy_Entity, player: Student_Entity, _delta: float):
	get_target(entity,player,_delta)
	entity.velocity = entity.position.direction_to(target) * entity.movement_component.movement_speed

func get_target(entity: Enemy_Entity, player: Student_Entity, _delta: float):
	angle += 1 * _delta
	var radius = desired_distance
	var x_pos = cos(angle)
	var y_pos = sin(angle)
	target = Vector2(radius * x_pos, radius * y_pos) + (player.position)
	
