class_name Ability_Aura_Farm
extends Ability_Entity

@export var fire_status_resource: Status_Effect_Resource

func _process(_delta):
	pass

func on_ready():
	_cooldown_complete = false
	if len(entity_pool) > 0:
		sort_entity_pool()
	return entity_pool.any(func(ent): return ent is Enemy_Entity)
	
func on_active():
	for entity: Enemy_Entity in entity_pool:
		entity.status_effects.add_status_effect_entity(fire_status_resource, self)
	return true
	
func on_recovery():
	return true
	
func on_cooldown():
	if cooldown.is_stopped() and not _cooldown_complete:
		cooldown.start()
	return _cooldown_complete

func _on_detection_body_entered(body):
	add_entity_to_pool(body)

func _on_detection_body_exited(body):
	remove_entity_from_pool(body)

func _on_cooldown_timeout():
	_cooldown_complete = true
