class_name Movement_Component
extends Node

@export_category("Meta")
## This can be any player or enemy.
@export var entity: CharacterBody2D
## This indicated whether or not th is component's controls
## should be linked with the player movement controls, or another system of
## movement, such the enemy movement stategies. 
@export var player_controls: bool = false
@export_category("Movement")
@export var base_movement_speed: float = 100
@export var dash_movement_percentage: float = 2.0
@export var is_dash: bool = false:
	set(value):
		if value:
			$"Dash Length Timer".start()
@export var active_movement_speed: float:
	set(value):
		pass
	get:
		## If state is not 'dashing' then return base_speed
		## if state is dashing, return base + (base * dash_increase)
		return (base_movement_speed * dash_movement_percentage 
			if is_dash else base_movement_speed)

var active_state: State:
	set(value):
		pass
	get:
		if has_node("StateMachine"):
			return $StateMachine.initial_state
		return active_state


func _on_dash_length_timer_timeout():
	is_dash = false
