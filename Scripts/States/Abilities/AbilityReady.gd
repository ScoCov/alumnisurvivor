extends State
class_name AbilityStateReady

@export var ability: AbilityPunch
@export var timer: Timer

##	Call when transitioning to this state
func enter():
	#print("Ready State")
	if timer:
		timer.stop()
	
##	Call when leaving this state
func exit() -> void:
	pass

##	Call every frame drawn
func update(_delta) -> void:
	## TODO: PERFORM LOGIC HERE TO DETERMINE IF ENEMY IS IN RANGE OR IF THERE IS A MANUAL COMMAND TO
	## ACTIVATE REGARDLESS OF THE PRECENSE OF AN ENEMY.
	Transitioned.emit(self,"AbilityActive")
	pass

##	Call every physics tick which can be seperate from the frames being drawn.
func physics_update(_delta)-> void:
	pass
	
