class_name EnemyMovementToPlayer
extends EnemyMovementStyle



func update(enemy: EnemyEntity, _delta: float):
	var true_pos = enemy.player.position
	var distance = enemy.position.distance_to(true_pos)
	var direction = enemy.position.direction_to(true_pos) 
	if distance > enemy.player_distance_min:
		enemy.velocity = direction * enemy.get_node("Composition/MovementSpeed").value 
		return false
	else: 
		return true
		#Transitioned.emit(self, "EnemyIdle")
