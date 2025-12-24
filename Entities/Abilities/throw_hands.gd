class_name Ability_Throw_Hands
extends Ability_Entity

@export var starting_pos_denominator: float = 8

## Unique Ability Variables
var rh_active: bool = true
var look_at_target: bool = true
var target:= Vector2.ZERO

@onready var hands_starting_position:= Vector2.ZERO
@onready var left_hand = $Facing/LeftHand
@onready var right_hand = $Facing/RightHand
@onready var active_hand: Node2D = right_hand if rh_active else left_hand


func _ready():
	$DetectionRange/CollisionShape2D.shape.radius = ability.attack_range
	$Facing/ColorRect.position = Vector2(ability.attack_range, 0)
	target == Vector2(ability.attack_range, 0)
	
func _physics_process(_delta):
		if len(entities_in_range) > 0:
			if len(entities_in_range) > 1:
				entities_in_range.sort_custom(func(_entity_a, _entity_b): return position.distance_to(_entity_a.position) < position.distance_to(_entity_b.position)) 
			if look_at_target:
				$Facing.look_at(entities_in_range[0].position)
	
## Returnting true to these state functions will trigger it to transition
func on_ready() -> bool:
	cooldown_current = 0
	attack_speed_current = 0
	look_at_target = true
	active_hand = right_hand if rh_active else left_hand
	active_hand.position = hands_starting_position
	return len(entities_in_range) > 0
	
func on_active() -> bool:
	target = Vector2(ability.attack_range, 0)
	active_hand = right_hand if rh_active else left_hand
	
	if look_at_target:
		left_hand.look_at(target)
		right_hand.look_at(target)
		var angle_to_target_left = ($Facing/LeftHand/Fist01128x128.position as Vector2).angle_to(target)
		var angle_to_target_right = ($Facing/RightHand/Fist01128x129.position as Vector2).angle_to(target)
		left_hand.rotate(angle_to_target_left)
		right_hand.rotate(angle_to_target_right)
	## If we're waiting on an attack speed cooldown
	if attack_speed_current > 0:
		attack_speed_current -= ability.attack_speed_rate * get_process_delta_time()
		return false ## repeat this step until we get a 0 or less.
	
	## Move the active hand's x-pos until it meet's the target's pos.
	print("%s" % active_hand.position.distance_to(position))
	if active_hand.position.distance_to(position) <= ability.attack_range:
		look_at_target = false
		active_hand.position.x += ability.projectile_speed * get_process_delta_time()
	else:
	## If the active hand is at or exceed's its' target position.
	## return hand to its' position. and increment projectile counter
		look_at_target = true
		active_hand.position = hands_starting_position if rh_active else -hands_starting_position
		projectiles_current += 1
		active_hand = right_hand if rh_active else left_hand
		rh_active = !rh_active
		attack_speed_current = ability.attack_speed * get_process_delta_time() ## Set to the maximum attack speed
	
	## If we used all the projectiles	
	if projectiles_current > ability.projectiles_max:
		return true
	return false
	
func on_recovery() -> bool:
	## Reset counters
	projectiles_current = 0
	rh_active = true
	right_hand.position = hands_starting_position
	left_hand.position = -hands_starting_position
	return true
	
func on_cooldown() -> bool:
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
	pass
