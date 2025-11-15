class_name EnemyMoving
extends State

@export var enemy_movement_component: Enemy_Movement_Component

##	Call when transitioning to this state
func enter():
	pass
	
##	Call when leaving this state
func exit() -> void:
	pass

func update(_delta):
	pass
		
func physics_update(_delta):
	if not enemy_movement_component.enemy_entity.player:
		return # Guardian Check, if no player, exit function with warning.
	if not enemy_movement_component.movement_type.update(_delta):
		Transitioned.emit(self, "EnemyIdle")
	enemy_movement_component.enemy_entity.move_and_slide()
		
