extends State
class_name AbilityStateRecover

@export var ability: Ability
var action: Callable

##	Call when transitioning to this state
func enter():
	#print("Entering: Recovery")
	if ability.has_method("on_recover"):
		action = ability.on_recover
	
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
		Transitioned.emit(self, "AbilityCooldown")
