extends AbilityState
class_name AbilityStateCooldown

@export var timer: Timer

##	Call when transitioning to this state
func enter():
	timer.start()
	
##	Call when leaving this state
func exit() -> void:
	pass

##	Call every frame drawn
func update(_delta) -> void:
	pass
	
##	Call every physics tick which can be seperate from the frames being drawn.
func physics_update(_delta)-> void:
	if action.call():
		Transitioned.emit(self, "AbilityReady")
