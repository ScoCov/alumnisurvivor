class_name WeaponEntity
extends Node2D

@export var ability: Ability 
@export var attack_type: StrategyAttackType

var target_pos: Vector2
var cooldown_complete: bool
var _notifier = func(attr_name, value): $'Label'.text = "%s: %s" % [attr_name ,str(value) ]

func _ready():
	for state in $StateMachine.get_children():
		if state is AbilityStateActive:
			state.action = active
		elif state is AbilityStateRecover:
			state.action = recover
		elif state is AbilityStateCooldown:
			state.action = cooldown
		elif state is AbilityStateReady:
			state.action = ready

func active(_delta) -> bool:
	return attack_type.active(self, _delta)

func recover(_delta) -> bool:
	return attack_type.recover(self, _delta)
	
func cooldown() -> bool:
	return attack_type.cooldown(self, 0)
	
func cooldown_timeout():
	return attack_type.cooldown_timeout(self)
	
func ready() -> bool:
	return attack_type.ready(self, 0)
