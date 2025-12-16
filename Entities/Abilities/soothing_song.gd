class_name Ability_Soothing_Song
extends Ability_Entity



func _ready():
	pass
	
func _physics_process(_delta):
	pass
	
## Returnting true to these state functions will trigger it to transition
func on_ready() -> bool:
	return false
	
func on_active() -> bool:
	return false
	
func on_recovery() -> bool:
	return false
	
func on_cooldown() -> bool:
	return false

func _on_detection_range_body_entered(body):
	if body is Enemy_Entity:
		body.movement_component.is_slowed = true
		var extant_entity = entities_in_range.any(func(_entity): return _entity == body)
		if not extant_entity:
			entities_in_range.append(body)

func _on_detection_range_body_exited(body):
	if body is Enemy_Entity:
		body.movement_component.is_slowed = false
		var extant_entity = entities_in_range.filter(func(_entity): return _entity == body)
		if extant_entity:
			entities_in_range.remove_at(entities_in_range.find_custom(func(_entity): return _entity == body))
