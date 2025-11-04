class_name FullHealthState
extends HealthState


##	Call when transitioning to this state
func enter():
	pass
	
##	Call when leaving this state
func exit() -> void:
	pass

##	Call every frame drawn
func update(_delta) -> void:
	if health_component.current_health / health_component.maximum_health < 1:
		Transitioned.emit(self, "Barely Hurt")
	elif health_component.current_health / health_component.maximum_health > 1:
		Transitioned.emit(self, "Over Health")

##	Call every physics tick which can be seperate from the frames being drawn.
func physics_update(_delta)-> void:
	pass
