extends State
class_name PlayerIdle

@export var player: StudentPlayer

##	Call when transitioning to this state
func enter():
	pass
	
##	Call when leaving this state
func exit() -> void:
	pass

func update(_delta):
	if player.velocity != Vector2() or Input.get_vector("move_left","move_right","move_up","move_down") != Vector2():
		Transitioned.emit(self, "PlayerMoving")
			
func physics_update(_delta):
	pass
