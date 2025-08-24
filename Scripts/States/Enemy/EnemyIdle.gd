extends State
class_name EnemyIdle

@export var enemy: EnemyEntity

##	Call when transitioning to this state
func enter():
	pass
	
##	Call when leaving this state
func exit() -> void:
	pass

func update(_delta):
	#if enemy.player and enemy.position.distance_to(enemy.player.get_parent().position + enemy.player.position) >= enemy.player_distance_min:
	if enemy.player and enemy.position.distance_to(enemy.player.position) >= enemy.player_distance_min:
		Transitioned.emit(self, "EnemyMoving")
			
func physics_update(_delta):
	pass
