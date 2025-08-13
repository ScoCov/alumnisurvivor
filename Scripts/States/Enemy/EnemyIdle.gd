extends State
class_name EnemyIdle

@export var enemy: EnemyEntity
@export var player: StudentPlayer

##	Call when transitioning to this state
func enter():
	pass
	
##	Call when leaving this state
func exit() -> void:
	pass

func update(_delta):
	if player:
		Transitioned.emit(self, "EnemyMoving")
			
func physics_update(_delta):
	pass
