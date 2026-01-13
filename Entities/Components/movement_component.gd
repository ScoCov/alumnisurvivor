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
@export var base_movement_speed: float = 120
@export var dash_movement_percentage: float = 2.5
@export var speed_modifier: float = 1.0
@export var is_dash: bool = false:
	set(value):
		if value:
			$"Dash Length Timer".start()
			if entity:
				entity.is_controllable = false
		is_dash = value
@export var active_movement_speed: float:
	set(value):
		pass
	get:
		if is_dash:
			return base_movement_speed * dash_movement_percentage
		return base_movement_speed
@export var dash_timer_length: float:
	set(value):
		$"Dash Length Timer".wait_time = value
		dash_timer_length = value

var last_movement_direction: Vector2
		
var active_state: State:
	set(value):
		pass
	get:
		if has_node("StateMachine"):
			return $StateMachine.initial_state
		return active_state

func _input(event):
	if event.is_action_pressed("dash", false):
		is_dash = true
		
func _on_dash_length_timer_timeout():
	if entity:
		entity.is_controllable = true
	$"Dash Length Timer".stop()
	entity.velocity *= 0
	is_dash = false
