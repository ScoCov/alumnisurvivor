class_name NearDeathState
extends HealthState


##	Call when transitioning to this state
func enter():
	entity.emit_signal("death")
	
##	Call when leaving this state
func exit() -> void:
	pass

##	Call every frame drawn
func update(_delta) -> void:
	pass

##	Call every physics tick which can be seperate from the frames being drawn.
func physics_update(_delta)-> void:
	pass
