extends AbilityState
class_name AbilityStateActive

##	Call when transitioning to this state
func enter():
	pass
	
##	Call when leaving this state
func exit() -> void:
	pass

##	Call every frame drawn
func update(_delta) -> void:
	pass 
	
##	Call every physics tick which can be seperate from the frames being drawn.
func physics_update(_delta)-> void:
	if action.call():
		Transitioned.emit(self, "AbilityRecover")
	
