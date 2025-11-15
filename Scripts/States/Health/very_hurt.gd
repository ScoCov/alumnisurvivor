class_name VeryHurtState
extends Health_State


##	Call when transitioning to this state
func enter():
	pass
	
##	Call when leaving this state
func exit() -> void:
	pass

##	Call every frame drawn
func update(_delta) -> void:
	if health_component.current_health as float / health_component.maximum_health as float < 0.25:
		Transitioned.emit(self, "Near Dead")
	elif health_component.current_health as float / health_component.maximum_health as float >= 0.50:
		Transitioned.emit(self, "Hurt")

##	Call every physics tick which can be seperate from the frames being drawn.
func physics_update(_delta)-> void:
	pass
