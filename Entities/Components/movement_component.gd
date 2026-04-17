class_name Movement_Component
extends Node2D

signal knockback
signal slowed
signal stunned

const BASE_MOVEMENT_SPEED: float = 85
const BASE_KNOCKBACK_SPEED: float = 100

@export var entity: Entity = get_parent()
@export var movement_speed: float = BASE_MOVEMENT_SPEED
@export var knockback_timer: Timer

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
			if knockback_timer.is_stopped():
				knockback_timer.start() 
			
func _ready():
	knockback_timer.connect("timeout", _on_knockback_timer_timeout)

func _on_knockback_timer_timeout():
	is_knocked_backed = false

func knockback_effect(knockback_value: float):
	is_knocked_backed = true
	knockback_speed += knockback_value
	knockback.emit()
