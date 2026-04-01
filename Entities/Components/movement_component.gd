class_name Movement_Component
extends Node2D

signal knockback
signal slowed
signal stunned

const BASE_MOVEMENT_SPEED: float = 85
const BASE_KNOCKBACK_SPEED: float = 100

@export var entity: Entity = get_parent()
@export var movement_speed: float = BASE_MOVEMENT_SPEED
@export var knockback_speed: float = BASE_KNOCKBACK_SPEED

var direction: Vector2
var check_for_slow: bool = false:
	set(value):
		check_for_slow = true
		if value:
			slowed.emit()
var check_for_stun: bool = false:
	set(value):
		check_for_stun = value
		if value:
			stunned.emit()
			
var is_knocked_backed: bool = false:
	set(value):
		is_knocked_backed = value
		if value:
			if $KnockbackTimer.is_stopped():
				$KnockbackTimer.start() 
			knockback.emit()
			
