class_name DeadState
extends Health_State


##	Call when transitioning to this state
func enter():
	##NOTE: When ever reviving mechanics are introduced they will likely be 
	## executed in this section.
	pass
	
##	Call when leaving this state
func exit() -> void:
	pass

##	Call every frame drawn
func update(_delta) -> void:
	pass

##	Call every physics tick which can be seperate from the frames being drawn.
func physics_update(_delta)-> void:
	pass
