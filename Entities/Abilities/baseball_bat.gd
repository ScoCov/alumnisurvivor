class_name Ability_Homerun
extends Ability_Entity

@onready var swinging = $Facing/Swinging
@onready var facing = $Facing
@onready var sprite_2d = $Facing/Swinging/Sprite2D
@onready var hitbox = $Facing/Swinging/Hitbox/CollisionPolygon2D
@onready var gpu_particles_2d = $Facing/Swinging/GPUParticles2D

#func _ready():
	#ability_factory(ability)

## Returnting true to these state functions will trigger it to transition
func on_ready() -> bool: ## Ready to go
	if len(entity_pool) <= 0 : return false
	swinging.rotation_degrees = -45 - (_items.get_attribute_bonus("attack_range") / PI)
	_cooldown_complete = false
	if len(entity_pool) >= 1:
		sort_entity_pool()
		target_entity = entity_pool[0]
		facing.look_at(target_entity.position)
		return target_entity.position.distance_to(entity.position) < _get_attribute_value("attack_range")
	return false
	
func on_active() -> bool: ## Attack
	## When active, it should disable the looking at function for Facing
	look_at_target = false
	_enable_bat(true)
	swinging.rotation_degrees += (ability.attack_speed + _get_attribute_value("attack_speed")) *  get_process_delta_time()
	return swinging.rotation_degrees >= 45 + (_items.get_attribute_bonus("attack_range") / PI)
	
func on_recovery() -> bool: ## Reset
	look_at_target = true
	_enable_bat(false)
	return true
	
func on_cooldown()-> bool: ## During Cooldown
	if entity is Student_Entity and entity.items.get_attribute_bonus("cooldown") != 0:
		cooldown.wait_time = ability.cooldown / (ability.cooldown 
		+ -(1 + entity.items.get_attribute_bonus("cooldown")))
	if cooldown.is_stopped():
		cooldown.start()
	return _cooldown_complete

func _on_hitbox_body_entered(body):
	body.health.apply_damage_rider(Damage_Rider.new(entity, self, entity.items))
	var total_knockback = (ability.knockback + _items.get_attribute_bonus("knockback"))
	if total_knockback != 0: 
		body.movement_component.knockback_effect(entity.position.direction_to(body.position), 
														total_knockback)
		
func _enable_bat(value: bool): # Disable ability to do damage (and make invisible)
	swinging.visible = value
	hitbox.disabled = !value
	gpu_particles_2d.emitting = value
	
func _on_cooldown_timeout(): ## Allow cooldown to finish
	_cooldown_complete = true

func _on_detection_range_body_entered(body):
	add_entity_to_pool(body)

func _on_detection_range_body_exited(body):
	remove_entity_from_pool(body)
