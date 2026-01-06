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
	if enemy_movement_component.movement_type:
		Transitioned.emit(self, "EnemyMoving")
			
func physics_update(_delta):
	pass
