class_name Stategy_Wander
extends Strategy_Enemy_Movement

signal too_far
signal wandering

@export var max_distance_from_player: float 
@export var wander_time: Timer
@export var entity: Enemy_Entity

@export_group("Debug")
@export var debug: bool = false
@export var direction_arrow: Sprite2D
@export var label: Label

var change_directions: bool = true
var direction: Vector2
			
## Used to facilitate debug information
func _debugger():
	if debug:
		if direction_arrow:
			direction_arrow.rotation = direction.angle()
		if label:
			label.text = "Distance: %s" % entity.position.distance_to(entity.player.position)
			
func update(_entity: Enemy_Entity, _delta: float):
	## Grab Variables to be used in the function
	var distance = entity.position.distance_to(entity.player.position)
	var slow_entity: Status_Slow
	var speed: float = movement_component.movement_speed
	
	## Determine which wander_function to use:
	if change_directions:
		if distance < max_distance_from_player:
			wander_around()
		else:
			wander_back()
		if wander_time.is_stopped(): ## If direction has been changed, restart the wander timer.
			wander_time.start()
	
	if movement_component.check_for_slow:
		slow_entity = _entity.status_effects.get_status_effect_by_name("slow_status")
		speed *= (1-slow_entity.slow_effect)
	_entity.velocity = direction.normalized() * speed
	_debugger()

func enable_change_direction():
	change_directions = true

func _on_wander_time_timeout():
	enable_change_direction()

func wander_around():
	direction = Vector2(randf_range(-1,1), randf_range(-1,1))
	change_directions = false
	wandering.emit()

func wander_back():
	wander_time.stop()
	change_directions = false
	direction = entity.position.direction_to(entity.player.position)
	too_far.emit()
