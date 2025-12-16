class_name Ability_Homerun
extends Ability_Entity

var look_at_target: bool = true

func _ready():
	pass
	
func _physics_process(_delta):
	if len(entities_in_range) > 0:
		if len(entities_in_range) > 1:
			entities_in_range.sort_custom(func(_entity_a, _entity_b): return position.distance_to(_entity_a.position) < position.distance_to(_entity_b.position)) 
		if look_at_target:
			$Facing.look_at(entities_in_range[0].position)
	
## Returnting true to these state functions will trigger it to transition
func on_ready() -> bool:
	$Facing/SwingingArm.rotation_degrees = -45 * ability.area
	cooldown_current = 0
	return len(entities_in_range) > 0 and entities_in_range[0].position.distance_to(entities_in_range[0].player.position) < ability.attack_range/2
	
	
func on_active() -> bool:
	## When active, it should disable the looking at function for Facing
	look_at_target = false
	$Facing/SwingingArm/BaseballBat.visible = true
	$Facing/SwingingArm.rotation_degrees += ability.projectile_speed * get_process_delta_time()
	if $Facing/SwingingArm.rotation_degrees >= 45 * ability.area:
		return true
	return false
	
func on_recovery() -> bool:
	look_at_target = true
	$Facing/SwingingArm/BaseballBat.visible = false
	return true
	
func on_cooldown()-> bool:
	cooldown_current += ability.cooldown_rate * get_process_delta_time()
	return cooldown_current >= ability.cooldown_time
	
func _on_detection_range_body_entered(body):
	if body is Enemy_Entity:
		var extant_entity = entities_in_range.any(func(_entity): return _entity == body)
		if not extant_entity:
			entities_in_range.append(body)

func _on_detection_range_body_exited(body):
	if body is Enemy_Entity:
		var extant_entity = entities_in_range.filter(func(_entity): return _entity == body)
		if extant_entity:
			entities_in_range.remove_at(entities_in_range.find_custom(func(_entity): return _entity == body))

func _on_hitbox_body_entered(body):
	if body is Enemy_Entity:
		body.health.attempt_damage(self, -1)
		var direction = player.position.direction_to(body.position)
		#var value = ability.knockback ##TEST: Needs a Variable
		body.movement_component.is_knocked_backed = true
		body.velocity += direction * ability.knockback
