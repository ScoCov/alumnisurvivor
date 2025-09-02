extends State
class_name EnemyMoving

@export var enemy: EnemyEntity

#const DEFAULT_MOVEMENT_SPEED: float = 100

##	Call when transitioning to this state
func enter():
	pass
	
##	Call when leaving this state
func exit() -> void:
	pass

func update(_delta):
	pass
		
func physics_update(_delta):
	if not enemy.player:
		return # Sentinel Check, if no player, exit function with warning.
	if enemy.movement_type.update(enemy, _delta):
		Transitioned.emit(self, "EnemyIdle")
	enemy.move_and_slide()
		
