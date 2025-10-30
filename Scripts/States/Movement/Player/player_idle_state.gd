extends MovementState
class_name PlayerIdleState


##	Call when transitioning to this state
func enter():
	pass
	
##	Call when leaving this state
func exit() -> void:
	pass

func update(_delta):
	if Input.get_vector("move_left","move_right","move_up","move_down"):
		Transitioned.emit(self, "moving")
			
func physics_update(_delta):
	pass
