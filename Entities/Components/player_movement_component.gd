class_name Player_Movement_Component
extends Movement_Component

@export var player_controls: bool = false
@export var dash_manager: Dash_Manager

@export_category("Dash Settings")
@export var dash_movement_percentage: float = 5.5
@export var dash_timer_length: float:
	set(time):
		dash_timer_length = time
		dash_timer.wait_time = dash_timer_length

@onready var dash_timer: Timer = $"Dash Timer"
@onready var dash_boom = $DashBoom

var is_dash: bool = false:
	set(value):
		if value:
			if dash_timer.is_stopped():
				dash_timer.start()
			player_controls = false
		is_dash = value

var can_dash: bool:
	get:
		return dash_manager.cand_dash and not is_dash
		
var is_moving: bool: 
	get:
		return entity.velocity.normalized() != Vector2.ZERO
		
var _item_movement_bonus: float 

func _input(event):
	if player_controls:
		direction = Input.get_vector("move_left","move_right","move_up","move_down")
		_item_movement_bonus = entity.items.get_attribute_bonus("movement_speed")
	if event.is_action_pressed("dash", false):
		if can_dash and is_moving:
			is_dash = true
			dash_manager.consume_dash()
		
func _on_dash_length_timer_timeout():
	is_dash = false

func _process(_delta):
	var speed: float = movement_speed
	if _item_movement_bonus != 0:
		speed *= (1 + _item_movement_bonus)
	if player_controls:
		entity.velocity = speed * direction
	elif !player_controls and is_dash:
		entity.velocity = (speed * dash_movement_percentage) * direction 
	elif !player_controls and !is_dash:
		entity.velocity *= 0
		direction *= 0
		player_controls = true
		if player_controls:
			direction = Input.get_vector("move_left","move_right","move_up","move_down")
	entity.move_and_slide()
