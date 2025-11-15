extends State
class_name EnemyIdle

@export var enemy_movement_component: Enemy_Movement_Component

##	Call when transitioning to this state
func enter():
	pass
	
##	Call when leaving this state
func exit() -> void:
	pass

func update(_delta):
	#if enemy.player and enemy.position.distance_to(enemy.player.get_parent().position + enemy.player.position) >= enemy.player_distance_min:
	if enemy_movement_component.enemy_entity.player:
		Transitioned.emit(self, "EnemyMoving")
			
func physics_update(_delta):
	pass
