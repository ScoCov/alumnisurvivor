extends Node
class_name State

#region Description
##	Schema/Interface for all State related classes.
##	None of the properties (variables), signals, functions, or any other part 
##	will have any logic in them. This is to be used as an skeleton for the 
##	actual states to unify on how they work.
##
##	To be a state it's required to have these. You will extend this Class "State" when
##	creating a new state. 
#endregion

signal Transitioned ##	Used to specially tell Godot that this kind of action is taking place.

##	Call when transitioning to this state
func enter():
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
