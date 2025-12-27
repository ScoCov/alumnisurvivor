class_name Ability_Homerun
extends Ability_Entity

var look_at_target: bool = true
@onready var damage_component = $DamageComponent


func _ready():
	damage_component.base_damage = ability.base_damage
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
	return len(entities_in_range) > 0 and entities_in_range[0].position.distance_to(entities_in_range[0].player.position) < ability.attack_range
	
func on_active() -> bool:
	## When active, it should disable the looking at function for Facing
	look_at_target = false
	#$Facing/SwingingArm.visible = true
	_bat_disable(true)
	$Facing/SwingingArm.rotation_degrees += ability.projectile_speed * get_process_delta_time()
	if $Facing/SwingingArm.rotation_degrees >= 45 * ability.area:
		return true
	return false
	
func on_recovery() -> bool:
	look_at_target = true
	#$Facing/SwingingArm.visible = false
	_bat_disable(false)
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
		body.health.attempt_damage(self, -damage_comp.base_damage)
		var direction = player.position.direction_to(body.position)
		if ability.knockback != 0:
			body.movement_component.knockback_effect(direction, ability.knockback)
		
func _bat_disable(value: bool):
	$Facing/SwingingArm.visible = value
	$Facing/SwingingArm/Area2D.disable_mode = !value
