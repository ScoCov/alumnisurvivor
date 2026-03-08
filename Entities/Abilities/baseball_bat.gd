class_name Ability_Homerun
extends Ability_Entity

var RESOURCE = Global.ABILITIES.rfind_custom(func(child): return child.id == "baseball_bat")

@onready var swinging = $Facing/Swinging
@onready var facing = $Facing
@onready var sprite_2d = $Facing/Swinging/Sprite2D
@onready var cooldown = $Cooldown
@onready var hitbox = $Facing/Swinging/Hitbox/CollisionPolygon2D


var _cooldown_complete = false

func _process(delta):
	$Label.text = "State: %s (%s)" % [$StateMachine.current_state.name, cooldown.wait_time]
	
func _ready():
	#Push all the ability resource stuff into the Damage and Cooldown component.
	ability = Global.ABILITIES[RESOURCE]
	damage.base_damage = ability.base_damage
	damage.critical_hit_chance = ability.critical_hit_chance
	damage.critical_damage_multiplier = ability.critical_damage_multiplier

## Returnting true to these state functions will trigger it to transition
func on_ready() -> bool: ## Ready to go
	if len(entity_pool) <= 0 : return false
	swinging.rotation_degrees = -45 
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
	#var _attribute_value = ability.attack_speed 
	##BUG: ability.attack_speed is coming in as 0.5, ignoring the resource. Using Default Resource value and not updating the actual baseball_bat.tres
	var base_value = ability.attack_speed
	var item_value = _get_attribute_value("attack_speed")
	#var _attribute_value = ability.attack_speed + _get_attribute_value("attack_speed")
	var _attribute_value = base_value + item_value
	swinging.rotation_degrees += _attribute_value *  get_process_delta_time()
	#swinging.rotation_degrees += _attribute_value 
	if swinging.rotation_degrees >= 45 :
		return true
	return false
	
func on_recovery() -> bool: ## Reset
	look_at_target = true
	_enable_bat(false)
	return true
	
func on_cooldown()-> bool: ## During Cooldown
	var value = 1
	if entity is Student_Entity and entity.items.get_attribute_bonus("cooldown") != 0:
		value = entity.items.get_attribute_bonus("cooldown")
		cooldown.wait_time = ability.cooldown / (ability.cooldown + -value)
	if cooldown.is_stopped():
		cooldown.start()
	return _cooldown_complete

func _on_hitbox_body_entered(body):
	if body is Entity:
		var item_values_damage = entity.items.get_attribute_bonus("damage")
		var item_values_crit_chance = entity.items.get_attribute_bonus("critical_chance")
		var item_values_crit_damage = entity.items.get_attribute_bonus("critical_damage")
		var base_damage = ability.base_damage
		var modded_value = floori(-(base_damage + ((base_damage * item_values_damage))))
		var is_critical = randf_range(0,1) < (ability.critical_hit_chance + item_values_crit_chance)
		if is_critical:
			modded_value *= floori(ability.critical_damage_multiplier + item_values_crit_damage)
			print("Critical Hit! (%s => %s)" % [base_damage, modded_value])
		var damage_rider:= Damage_Rider.new(entity, self, entity.items)
		#body.health.attempt_damage(modded_value, ability, damage) ##FIXIT
		body.health.apply_damage_rider(damage_rider)
		var direction = entity.position.direction_to(body.position)
		if ability.knockback != 0:
			body.movement_component.knockback_effect(direction, ability.knockback)
		
func _enable_bat(value: bool): # Disable ability to do damage (and make invisible)
	swinging.visible = value
	hitbox.disabled = !value
func _on_cooldown_timeout(): ## Allow cooldown to finish
	_cooldown_complete = true
 
func _on_area_2d_body_exited(body):
	if body is Enemy_Entity:
		if entity_pool.any(func(entity): return entity == body):
			entity_pool.remove_at(entity_pool.find_custom(func(entity): return entity == body))

func _on_detection_range_body_entered(body):
	add_entity_to_pool(body)

func _on_detection_range_body_exited(body):
	remove_entity_from_pool(body)


func _on_hitbox_area_entered(area):
	pass # Replace with function body.
