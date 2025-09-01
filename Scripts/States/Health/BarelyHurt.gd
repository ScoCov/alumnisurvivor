class_name BarelyHurtState
extends HealthState


##	Call when transitioning to this state
func enter():
	pass
	
##	Call when leaving this state
func exit() -> void:
	pass

##	Call every frame drawn
func update(_delta) -> void:
	if entity.health.current_health / entity.health.max_health >= 1:
		Transitioned.emit(self, "FullHealth")
	elif entity.health.current_health / entity.health.max_health < 0.75:
		Transitioned.emit(self, "Hurt")

##	Call every physics tick which can be seperate from the frames being drawn.
func physics_update(_delta)-> void:
	pass
