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
@export var dash_movement_percentage: float = 5.5
@export var speed_modifier: float = 1.0
@export var is_dash: bool = false:
	set(value):
		if value:
			$"Dash Length Timer".start()
			if entity:
				entity.is_controllable = !value
		is_dash = value
@export var active_movement_speed: float:
	set(value):
		pass
	get:
		var item_value: float = (entity as Student_Entity).items.get_attribute_bonus(resource.id)
		if item_value != 0:
			var temp = false 
		var _base_speed = base_movement_speed * (1+item_value )
		if is_dash:
			return _base_speed * dash_movement_percentage 
		return _base_speed
		
@export var dash_timer_length: float:
	set(value):
		$"Dash Length Timer".wait_time = value
		dash_timer_length = value

var last_movement_direction: Vector2
var resource: AttributeResource = load("res://Resources/Data/Attributes/movement_speed.tres")
var active_state: State:
	set(value):
		pass
	get:
		if has_node("StateMachine"):
			return $StateMachine.initial_state
		return active_state

var dashes: Dash_Manager:
	get():
		return entity.dashes

var can_dash: bool:
	get:
		return dashes.cand_dash and not is_dash
		
var is_moving: bool: 
	get:
		return entity.velocity.normalized() != Vector2.ZERO

var direction: Vector2

@onready var dash_boom = $DashBoom

func _input(event):
	if event.is_action_pressed("dash", false):
		if can_dash and is_moving:
			dashes.consume_dash()
			dash_boom.emitting = true
			dash_boom.position = entity.position
			dash_boom.direction = Vector3(direction.x,direction.y,0)
			is_dash = true
		
func _on_dash_length_timer_timeout():
	if entity:
		entity.is_controllable = true
	entity.velocity *= 0
	dash_boom.emitting = false
	is_dash = false
