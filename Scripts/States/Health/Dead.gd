class_name DeadState
extends HealthState


##	Call when transitioning to this state
func enter():
	pass
	
##	Call when leaving this state
func exit() -> void:
	pass

##	Call every frame drawn
func update(_delta) -> void:
	if entity.health.current_health < 1:
		Transitioned.emit(self, "dead")
	elif entity.health.current_health / entity.health.max_health >= 0.25:
		Transitioned.emit(self, "very_hurt")

##	Call every physics tick which can be seperate from the frames being drawn.
func physics_update(_delta)-> void:
	pass
