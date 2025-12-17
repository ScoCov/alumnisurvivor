class_name Ability_Soothing_Song
extends Ability_Entity

@export var slow_strength: float = 0.25

@export var pulse_rate: float = 1
@export var min_transparency: float = 0.25
@export var max_transparency: float = 1.0

var life_timer: float = Time.get_date_string_from_system().to_float()
var slow_status_package: PackedScene = preload("res://Entities/StatusEffects/Statuses/slow_status.tscn")
var alpha_value: float = 0.5
var _signed: int = 1.0

func _ready():
	$DetectionRange/CollisionShape2D.shape.radius = ability.attack_range
	pass
	
func _physics_process(_delta):
	pass
	
## Returnting true to these state functions will trigger it to transition
func on_ready() -> bool:
	return true
	
func on_active() -> bool:
	alpha_value += _signed * (pulse_rate * get_process_delta_time())
	if alpha_value <= min_transparency or alpha_value >= max_transparency:
		_signed *= -1
	for entity in entities_in_range:
		if not entity.find_child("StatusEffects").has_node("SlowStatus"):
				var _slow = slow_status_package.instantiate()
				_slow.entity = entity
				_slow.speed_modification = slow_strength
				entity.find_child("StatusEffects").add_child(_slow)
		else:
			var slow_effect_index: int = entity.status_effects.get_children().find_custom(func(status): return status.name == "SlowStatus")
			var slow_effect: Status_Slow = entity.status_effects.get_child(slow_effect_index)
			slow_effect.refresh()
	$Facing.modulate = Color(1,1,1, alpha_value)
	return false
	
func test(entity: Enemy_Entity) -> bool:
	return false
	
func on_recovery() -> bool:
	return false
	
func on_cooldown() -> bool:
	return false

func _on_detection_range_body_entered(body):
	if body is Enemy_Entity:
		if body.has_node("StatusEffects"):
			if not body.find_child("StatusEffects").has_node("SlowStatus"):
				var _slow: Status_Slow = slow_status_package.instantiate()
				_slow.entity = body
				_slow.speed_modification = slow_strength
				body.find_child("StatusEffects").add_child(_slow)
		var extant_entity = entities_in_range.any(func(_entity): return _entity == body)
		if not extant_entity:
			entities_in_range.append(body)

func _on_detection_range_body_exited(body):
	if body is Enemy_Entity:
		var extant_entity = entities_in_range.filter(func(_entity): return _entity == body)
		if extant_entity:
			entities_in_range.remove_at(entities_in_range.find_custom(func(_entity): return _entity == body))
