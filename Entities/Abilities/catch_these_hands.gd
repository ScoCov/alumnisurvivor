class_name Ability_Catch_These_Hands
extends Ability_Entity


#region Development Notes
## Right now, the arms come swinging out from the side and go towards the halfway point of 
## the detection area. I cannot figure out how to get them to aim at the target point,
## which was labled as P3 in my notebook. 
## 
## I have the seperate arms operate independently (somewhat) of each other. 
## When they are at the half-way point, the immediately dissappear and go back to their starting 
## position. I will also need to disable the hit box, current it's still enabled. 
##
## The ability is currently ignoring the attack_speed, or the delay between each
## hand. It does seem to add the
#endregion

@onready var left_hand = $Facing/LeftHand
@onready var right_hand = $Facing/RightHand
##TODO: Need to figure out a better angle for the hands. 
@onready var hands_starting_pos: Vector2 = Vector2(0, ability.attack_range/4)

var rh_active: bool = false

func _ready():
	$DetectionRange.get_child(0).shape.radius = ability.attack_range
	left_hand.scale *= ability.area
	right_hand.scale *= ability.area
	left_hand.position = -hands_starting_pos
	right_hand.position = hands_starting_pos

func _physics_process(_delta):
	if len(entities_in_range) > 0:
		if len(entities_in_range) > 1:
			entities_in_range.sort_custom(func(_entity_a, _entity_b): return position.distance_to(_entity_a.position) < position.distance_to(_entity_b.position)) 
		$Facing.look_at(entities_in_range[0].position)
	
## Returnting true to these state functions will trigger it to transition
func on_ready() -> bool:
	cooldown_current = 0
	return len(entities_in_range) > 0 and entities_in_range[0].position.distance_to(entities_in_range[0].player.position) < ability.attack_range/2
	
func on_active() -> bool:
	## Movementspeed with Delta-time taken into account.
	if len(entities_in_range) != 0: return false
	var target:= entities_in_range[0] ## Closest Enemy
	var speed = ability.projectile_speed * get_process_delta_time() 
	var active_hand = right_hand if rh_active else left_hand ## assign hand to be used
	var direction ##
	if attack_speed_current > 0: ## If there is something to be counted down, then count it down.
		attack_speed_current -= ability.attack_speed_rate * get_process_delta_time()
		right_hand.visible = false
		left_hand.visible = false
	else:
		## If right_hand active
		if rh_active:
			right_hand.visible = true
			right_hand.position += Vector2(speed, -speed)
		else: ## If left_hand active
			left_hand.visible = true
			left_hand.position += Vector2(speed, speed)
	
		if active_hand.position.x >= ability.attack_range/2: 
			active_hand.position = hands_starting_pos if rh_active else -hands_starting_pos
			projectiles_current +=1
			rh_active = !rh_active
			attack_speed_current = ability.attack_speed
			active_hand.visible = false 
			
	return projectiles_current >= ability.projectiles_max

func on_recovery() -> bool:
	attack_speed_current = 0
	projectiles_current = 0
	left_hand.position = -hands_starting_pos
	right_hand.position = hands_starting_pos
	$Facing/LeftHand.visible = false
	$Facing/RightHand.visible = false
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
	if body is Enemy_Entity:
		body.health.attempt_damage(self, -3)
		
		
	
