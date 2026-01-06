class_name EnemyMoving
extends State

@export var movement_component: Enemy_Movement_Component

##	Call when transitioning to this state
func enter():
	movement_component.movement_type.enter()
	
##	Call when leaving this state
func exit() -> void:
	movement_component.movement_type.exit()

func update(_delta):
	pass
		
func physics_update(_delta):
	if not movement_component.movement_type:
		Transitioned.emit(self, "EnemyIdle")
	movement_component.movement_type.update(movement_component.entity, movement_component.entity.player, _delta)
	movement_component.entity.move_and_slide()
		
