class_name AbilityState
extends State

@export var player_student: StudentPlayer
@export var ability: Ability

##	Call when transitioning to this state
func enter():
	#if _ability is Ability:
		#pass
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
