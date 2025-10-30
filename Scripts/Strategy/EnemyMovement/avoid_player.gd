class_name EnemyMovementAvoidPlayer
extends EnemyMovementStrategy


func update(enemy: EnemyEntity, _delta: float):
	var true_pos = enemy.player.position
	var distance = enemy.position.distance_to(true_pos)
	var direction = enemy.position.direction_to(true_pos) 
	var avg_dist = (enemy.player_disntance_max + enemy.player_distance_min)/2
	if distance > avg_dist:
		enemy.velocity = direction * enemy.get_node("Composition/MovementSpeed").value 
	elif distance < avg_dist:
		enemy.velocity = -direction * enemy.get_node("Composition/MovementSpeed").value 
	else: 
		return true
	return false
