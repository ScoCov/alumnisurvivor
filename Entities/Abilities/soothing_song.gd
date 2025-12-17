class_name Ability_Soothing_Song
extends Ability_Entity

@export_range(1,10) var pulse_rate: int = 1

var life_timer: float = Time.get_date_string_from_system().to_float()
var counter: int = 0


func _ready():
	$DetectionRange/CollisionShape2D.shape.radius = ability.attack_range
	pass
	
func _physics_process(_delta):
	pass
	
## Returnting true to these state functions will trigger it to transition
func on_ready() -> bool:
	return true
	
func on_active() -> bool:
	var sin_pulse_value = sin(counter * get_process_delta_time()) + cos(counter * get_process_delta_time())
	$Facing.modulate = Color(1,1,1, sin_pulse_value)
	$Label.text = "value(%s): %s" % [counter, sin_pulse_value]
	counter += pulse_rate
	return false
	
func on_recovery() -> bool:
	return false
	
func on_cooldown() -> bool:
	return false

func _on_detection_range_body_entered(body):
	if body is Enemy_Entity:
		body.movement_component.is_slowed = true
		body.movement_component.speed_modifier -= damage_comp.base_damage
		var extant_entity = entities_in_range.any(func(_entity): return _entity == body)
		if not extant_entity:
			entities_in_range.append(body)

func _on_detection_range_body_exited(body):
	if body is Enemy_Entity:
		body.movement_component.is_slowed = false
		body.movement_component.speed_modifier += damage_comp.base_damage
		var extant_entity = entities_in_range.filter(func(_entity): return _entity == body)
		if extant_entity:
			entities_in_range.remove_at(entities_in_range.find_custom(func(_entity): return _entity == body))
