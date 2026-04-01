class_name Ability_Stink_Bomb
extends Ability_Entity

const poison_pool = preload("res://Entities/Abilities/stink_pool.tscn")

#func _ready():
	#ability_factory(ability)
	
func _process(_delta):
	$Label.text = "Current State: %s" % state_machine.current_state.name

func on_ready():
	_cooldown_complete = false
	if len(entity_pool) > 0:
		sort_entity_pool()
		target_entity = entity_pool[0]
	return entity_pool.any(func(ent): return ent is Enemy_Entity)
	
func on_active():
	var _source = get_tree().get_root().get_node("MapEntrance")
	_source.call_deferred("add_child", _create_pool() )
	return true

func on_recovery():
	return true
	
func on_cooldown():
	if cooldown.is_stopped():
		cooldown.start()
	return _cooldown_complete

func _create_pool() -> Stink_Pool:
	var new_pool = poison_pool.instantiate()
	if target_entity:
		new_pool.position = target_entity.position
		new_pool.parent_ability = self
		new_pool.parent_entity = entity
	return new_pool

func _on_detection_body_entered(body):
	add_entity_to_pool(body)

func _on_detection_body_exited(body):
	remove_entity_from_pool(body)

func _on_cooldown_timeout():
	_cooldown_complete = true
