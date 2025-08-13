extends State
class_name AbilityStateActive

@export var ability: AbilityPunch
var action: Callable

##	Call when transitioning to this state
func enter():
	#print("Active State")
	if ability.has_method("on_active"):
		action = ability.on_active
		
##	Call when leaving this state
func exit() -> void:
	pass

##	Call every frame drawn
func update(_delta) -> void:
	pass
	
##	Call every physics tick which can be seperate from the frames being drawn.
func physics_update(_delta)-> void:
	if not ability:
		return
	if action.call():
		Transitioned.emit(self, "AbilityRecover")
