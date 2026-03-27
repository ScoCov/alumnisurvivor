class_name Ability_Guitar_Screech
extends Ability_Entity

@export var radius_growth = 10
@export var growth_rate = 250
@export var start_radius = 10
@export var max_growth = 100

@onready var hitbox = $Hitbox/CollisionShape2D

var direction: Vector2

func _ready():
	ability_factory(ability)

func _draw():
	draw_circle(Vector2.ZERO,radius_growth, Color.RED,true)
	hitbox.shape.radius = radius_growth
	
func on_ready():
	cooldown.wait_time = ability.cooldown * (1 +(_items.get_attribute_bonus("cooldown")))
	detection.shape.radius = max_growth + (_items.get_attribute_bonus("attack_range"))
	_cooldown_complete = false
	hitbox.disabled = true
	if !entity:
		return true
	return entity_pool.any(func(ent): return ent is Enemy_Entity)

func on_active():
	hitbox.disabled = false
	radius_growth += growth_rate * get_process_delta_time()
	queue_redraw()
	return radius_growth >= max_growth

func on_recovery():
	radius_growth = start_radius
	hitbox.disabled = true
	queue_redraw()
	return radius_growth == start_radius
	
func on_cooldown():
	if cooldown.is_stopped():
		cooldown.start()
	return _cooldown_complete

func _on_detection_body_entered(body):
	add_entity_to_pool(body)

func _on_detection_body_exited(body):
	remove_entity_from_pool(body)

func _on_hitbox_body_entered(body):
	direction = entity.position.direction_to(body.position)
	var stun_effect = Global.STATUS_EFFECTS.find_custom(func(stat): return stat is Status_Stun)
	(body as Enemy_Entity).status_effects.add_status_effect(Global.STATUS_EFFECTS[stun_effect])
	(body as Enemy_Entity).health.apply_damage_rider(Damage_Rider.new(entity,self, entity.items))

func _on_cooldown_timeout():
	_cooldown_complete = true
