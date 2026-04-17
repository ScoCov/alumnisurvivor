class_name Ability_Pencil_Fan
extends Ability_Entity

const COOLDOWN_MIN: float = 0.05
const COOLDOWN_MAX: float = 10.0
const PENCIL_PROJECTILE = preload("res://Entities/Abilities/pencil_projectile.tscn")

@export_range(1,10) var number_of_projectiles : int = 3
@onready var facing = $Facing
@onready var detection_shape_2d = $Detection/CollisionShape2D
@onready var attack_duration = $AttackDuration

var _attack_complete: bool = false
var _ready_to_throw_again: bool = true

func _ready():
	pass
	
func _process(_delta):
	if target_entity:
		facing.look_at(target_entity.position)
	pass
	
func on_ready():
	if len(entity_pool) <= 0 and not debug: return false
	detection_shape_2d.shape.radius = ability.attack_range + _items.get_attribute_bonus("attack_range")
	_cooldown_complete = false
	_ready_to_throw_again = true
	if len(entity_pool) >= 1:
		sort_entity_pool()
		target_entity = entity_pool[0]
		facing.look_at(target_entity.position )
		return target_entity.position.distance_to(entity.position) < ability.attack_range + entity.items.get_attribute_bonus("attack_range")
	return false
	
func on_active():
	if not _ready_to_throw_again and _attack_complete: return true
	if not _ready_to_throw_again: return false
	_create_fan()
	_ready_to_throw_again = false
	if attack_duration.is_stopped():
		attack_duration.start()
	return _attack_complete

func on_recovery():
	_ready_to_throw_again = true
	return true
	
func on_cooldown():
	if cooldown.is_stopped() and not _cooldown_complete:
		cooldown.wait_time = clamp(ability.cooldown * (1 + _items.get_attribute_bonus("cooldown")), COOLDOWN_MIN ,COOLDOWN_MAX) 
		cooldown.start()
	return _cooldown_complete
	
func _on_cooldown_timeout():
	_cooldown_complete = true

func _on_attack_duration_timeout():
	_attack_complete = true

func _on_detection_body_entered(body):
	add_entity_to_pool(body)

func _on_detection_body_exited(body):
	remove_entity_from_pool(body)

func _create_fan():
	var _angle = facing.rotation_degrees
	for index in range(0,number_of_projectiles):
		var _source = get_tree().get_root().get_node("MapEntrance")
		_source.call_deferred("add_child", _create_pencil(index, _angle))

func _create_pencil(index: int, _new_angle = null) -> Pencil_Projectile:
	var _pencil: Pencil_Projectile = PENCIL_PROJECTILE.instantiate()
	_pencil.position = entity.position  
	_pencil.parent_ability = self
	_pencil.parent_entity = entity
	_pencil.target_location = target_entity.position
	var arc_rad: float = deg_to_rad(15)
	var increment: float = arc_rad / (number_of_projectiles - 
		1 if number_of_projectiles <= 1 else 1)
	var a = (facing.rotation + increment * (index - floor(number_of_projectiles/2.0)) - arc_rad/(number_of_projectiles as float))
	_pencil.angle = a 
	return _pencil
