class_name Ability
extends Node2D


#NOTE - TO SELF: Please always check for the object - do not assume it's there.
@export var ability: AbilityResource
@export var player: StudentPlayer
	
func _process(_delta):
	if $StateMachine and $StateMachine.current_state:
		$StateMachine.current_state.update(_delta)
	elif (!$StateMachine):
		print("Does not detect Statemachine")
		
## Called when the ability is ready to be triggered again
func on_ready():
	pass
	
## Called when the ability is active phase
func on_active(_delta):
	pass
	
## Called to have the 
func on_recovery(_delta):
	pass

## Called when the weapon is not doing anything and is waiting for the cooldown timer to complete.	
func on_cooldown(_delta):
	pass
	
func on_enter():
	pass
	
func on_exit():
	pass
