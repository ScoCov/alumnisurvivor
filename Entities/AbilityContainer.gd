class_name AbilityContainer
extends Node2D

@export var ability: Ability 

var cooldown_complete: bool
var set_actions: bool = false

@warning_ignore("unused_private_class_variable")
var _notifier = func(attr_name, value): $'Label'.text = "%s: %s" % [attr_name ,str(value) ]

func _ready():
	if self.get_child_count() > 0 && !set_actions: 
		for state in self.get_node("StateMachine").get_children():
			if state is AbilityStateActive:
				state.action = active
			elif state is AbilityStateRecover:
				state.action = recover
			elif state is AbilityStateCooldown:
				state.action = cooldown
			elif state is AbilityStateReady:
				state.action = ready

		set_actions = true
	
func active(_delta) -> bool:
	return false

func recover(_delta) -> bool:
	return false
	
func cooldown() -> bool:
	return false
	
func cooldown_timeout():
	return false
	
func ready() -> bool:
	return false
