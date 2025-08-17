extends AbilityState
class_name AbilityStateReady

##	Call when transitioning to this state
func enter():
	pass
	
##	Call when leaving this state
func exit() -> void:
	pass

##	Call every frame drawn
func update(_delta: float) -> void:
	pass
					
##	Call every physics tick which can be seperate from the frames being drawn.
func physics_update(_delta: float)-> void:
	if (get_parent().get_parent() ).on_ready():
		Transitioned.emit(self, "Active")
	pass
