class_name WeaponEntity
extends Node2D

#@export var player: StudentPlayer
var cooldown_complete: bool = true

func _ready():
	if !$'CooldownTimer'.timeout:
		$'CooldownTimer'.connect("timeout", cooldown_timeout)
	for state in $StateMachine.get_children():
		if state is AbilityStateActive:
			state.action = active
			#print("Active Action Assigned")
		if state is AbilityStateRecover:
			state.action = recover
			#print("Recover Action Assigned")
		if state is AbilityStateCooldown:
			state.action = cooldown
			#print("Cooldown Action Assigned")
		if state is AbilityStateReady:
			state.action = ready
			#print("Ready Action Assigned")


func active() -> bool:
	cooldown_complete = false
	#print("Active")
	$'Marker2D/Sprite2D'.position.x += 10
	if $'Marker2D/Sprite2D'.position.x >= 200:
		return true
	return false
	
func recover() -> bool:
	#print("Recover")
	$'Marker2D/Sprite2D'.position.x -= 10
	if $'Marker2D/Sprite2D'.position.x <= 0:
		$'Marker2D/Sprite2D'.position.x = 0
		return true
	return false
	
func cooldown() -> bool:
	#print("Cooldown %s " % str(cooldown_complete))
	if $CooldownTimer.is_stopped():
		$CooldownTimer.start()
	return cooldown_complete
	
func cooldown_timeout():
	print("Cooldown Timeout")
	cooldown_complete = true
	
func ready() -> bool:
	#print("Ready %s" % str($'Marker2D/Sprite2D'.position))
	return cooldown_complete
