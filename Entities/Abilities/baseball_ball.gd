class_name Baseball_Ball
extends Ability_Entity

const COOLDOWN_MIN = 0.1
const COOLDOWN_MAX = 10

## Use already existing data 
var RESOURCE = Global.ABILITIES.rfind_custom(func(child): return child.id == "baseball_ball")
## Get the baseball_ball projectile scene ready for instantiation.
var BASEBALL = preload("res://Entities/Abilities/baseball_projectile.tscn")

## The actual sprite of the ability (Which is none here)
@onready var attack_duration = $AttackDuration
@onready var detection_collision_shape = $Detection/CollisionShape2D

var _attack_complete: bool = false
var _ready_to_throw_again: bool = true

func _process(_delta):
	$Label.text = "State: %s" % [state_machine.current_state.name]
	pass
	
func on_ready():
	if len(entity_pool) <= 0 : return false
	detection_collision_shape.shape.radius = ability.attack_range + entity.items.get_attribute_bonus("attack_range")
	
	_cooldown_complete = false
	if len(entity_pool) >= 1:
		sort_entity_pool()
		target_entity = entity_pool[0]
		#facing.look_at(target_entity.position)
		return target_entity.position.distance_to(entity.position) < ability.attack_range + entity.items.get_attribute_bonus("attack_range")
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
	_ready_to_throw_again = true
	return true
	
func on_cooldown():
	if cooldown.is_stopped():
		cooldown.wait_time = clamp(ability.cooldown * (1 + _items.get_attribute_bonus("cooldown")), COOLDOWN_MIN ,COOLDOWN_MAX) 
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
