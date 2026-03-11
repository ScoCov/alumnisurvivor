class_name Baseball_Ball
extends Ability_Entity

const COOLDOWN_MIN = 0.1
const COOLDOWN_MAX = 10

var RESOURCE = Global.ABILITIES.rfind_custom(func(child): return child.id == "baseball_ball")
var BASEBALL = preload("res://Entities/Abilities/baseball_projectile.tscn")

@onready var facing = $Facing
@onready var sprite_2d = $Facing/Sprite2D
@onready var state_machine = $StateMachine
@onready var detection = $Detection
@onready var cooldown = $Cooldown
@onready var attack_duration = $AttackDuration



var _cooldown_complete: bool = false
var _attack_complete: bool = false
var _ready_to_throw_again: bool = true

func _ready():
	ability = Global.ABILITIES[RESOURCE]
	damage.base_damage = ability.base_damage
	damage.critical_hit_chance = ability.critical_hit_chance
	damage.critical_damage_multiplier = ability.critical_damage_multiplier
	$Detection/CollisionShape2D.shape.radius = ability.attack_range
	cooldown.wait_time = ability.cooldown
	
func _process(_delta):
	$Label.text = "State: %s" % [state_machine.current_state.name]
	
func on_ready():
	if len(entity_pool) <= 0 : return false
	$Detection/CollisionShape2D.shape.radius = ability.attack_range + _items.get_attribute_bonus("attack_range")
	_ready_to_throw_again = true
	_cooldown_complete = false
	if len(entity_pool) >= 1:
		sort_entity_pool()
		target_entity = entity_pool[0]
		facing.look_at(target_entity.position)
		return target_entity.position.distance_to(entity.position) < _get_attribute_value("attack_range")
	return false
	
func on_active():
	## Create Baseball projectile.
	if not _ready_to_throw_again and _attack_complete: return true
	if not _ready_to_throw_again: return false
	var _baseball: Baseball_Projectile = BASEBALL.instantiate()
	_baseball.position = entity.position
	_baseball.parent_ability = self
	_baseball.parent_entity = entity
	if target_entity:
		_baseball.target_location = target_entity.position 
	else:
		_baseball.target_location = Vector2(randf(), randf())
	entity.get_parent().add_child(_baseball)
	_ready_to_throw_again = false
	if attack_duration.is_stopped():
		attack_duration.start()
	return _attack_complete
	
func on_recovery():
	return true
	
func on_cooldown():
	if cooldown.is_stopped():
		var cool = ability.cooldown
		var items = 1 + _items.get_attribute_bonus("cooldown")
		cooldown.wait_time = clamp(ability.cooldown * items, COOLDOWN_MIN ,COOLDOWN_MAX) 
		cooldown.start()
	return _cooldown_complete
	
func _on_detection_body_entered(body):
	add_entity_to_pool(body)

func _on_detection_body_exited(body):
	remove_entity_from_pool(body)

func _on_cooldown_timeout():
	_cooldown_complete = true


func _on_attack_duration_timeout():
	_attack_complete = true
