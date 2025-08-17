extends AbilityState
class_name AbilityStateReady

##	Call when transitioning to this state
func enter():
	pass
	
##	Call when leaving this state
func exit() -> void:
	pass

##	Call every frame drawn
func update(_delta: float, action: Callable = func(): pass) -> void:
	if !action:
		return
	if action.call():
		Transitioned.emit(self, "AbilityActive")
		
##	Call every physics tick which can be seperate from the frames being drawn.
func physics_update(_delta: float, action: Callable = func(): pass)-> void:
	pass
