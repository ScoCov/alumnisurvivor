class_name Ability_Entity
extends Node2D

signal ready_complete

#region Development Notes
## This is the base ability entity that will have all the other abilities based upon.
## each form should be an instantiated Ability_Entity.
#endregion
@export var entity: Entity
@export var ability: Ability_Resource
@export_range(1,4) var level: int = 1 

@export_group("Debug")
@export var debug: bool = true
@export var debug_loop: bool = false
@export var follow_mouse: bool = false
@export var custom_target: Vector2 = Vector2.ZERO


@onready var cooldown: Timer = $Cooldown
@onready var state_machine = $StateMachine
@onready var detection = $Detection/CollisionShape2D


## This stuff
var entity_pool: Array[Entity]
var target_entity: Entity
## Counters 
var attack_speed_current: float = 0.0
var projectiles_current: int = 0
var bounce_current: int = 0
var look_at_target: bool = true
var enable_attack: bool = false

@warning_ignore("unused_private_class_variable")
var _items: Item_Container:
	get():
		return Global.CURRENT_RUN.items
		
var _cooldown_complete: bool = false

func _get_configuration_warnings():
	var _msg: Array[String]
	var children = get_children()
	if !children.any(func(child): return child is State_Machine):
		_msg.append("Ability Entity Requires a State Machine")
	else:
		var children_required: Array[String] = ["Active", "Ready","Recovery","Cooldown"]
		var state_children = children.any(func(child): return child.name in children_required)
		if !state_children:
			_msg.append("Ability Entity's State machine requires these states; %s" % children_required)
	return _msg

func _ready():
	ready_complete.connect(ability_factory.bind(ability))
	ready_complete.emit()
	
func _physics_process(_delta):
	if not entity:
		position = get_global_mouse_position()
	pass
	
## Returnting true to these state functions will trigger it to transition
func on_ready() -> bool:
	return false
	
func on_active() -> bool:
	return false
	
func on_recovery() -> bool:
	return false
	
func on_cooldown() -> bool:
	return _cooldown_complete
	
func ability_factory(_resource: Ability_Resource):
	assert(ability != null, "Ability Entity must have an Ability_Resource connected")
	cooldown.wait_time = get_stat_float(_resource.cooldown)
	detection.shape.radius = get_stat_float(_resource.detection_range)
	
func add_entity_to_pool(_entity: Entity):
	if _entity is Enemy_Entity:
		var extant_entity = entity_pool.any(func(_entity_): return _entity_ == _entity)
		if not extant_entity:
			entity_pool.append(_entity)
				
func remove_entity_from_pool(_entity: Entity):
	if _entity is Enemy_Entity:
		var extant_entity = entity_pool.filter(func(_entity_): return _entity_ == _entity)
		if extant_entity:
			entity_pool.remove_at(entity_pool.find_custom(func(_entity_): return _entity_ == _entity))

## Sorts the entity pool from closest to furthers distance.
func sort_entity_pool():
	if len(entity_pool) > 0:
		if len(entity_pool) > 1:
			entity_pool.sort_custom(func(_entity_a, _entity_b): return get_parent().position.distance_to(_entity_a.position) < get_parent().position.distance_to(_entity_b.position)) 

func item_bonus(item_id: String) -> float:
	assert(entity.items, "Ability Entity cannot detect the Items manager for its' parent entity.")
	return entity.items.get_attribute_bonus(item_id)

func student_augment(attribute_id: String) -> float:
	if not entity is Player_Entity: return 0.0
	return entity.student_manager.get_bonus_by_attribute(attribute_id)

## Function used to obtain base attribute values based on the 
## ability's current level. This function will accept 3 different
## data types: Array[float], Array[int], and String. 
func get_stat(attribute: Variant):
	if attribute is Array[float]:
		return get_stat_float(attribute)
	elif attribute is Array[int]:
		return get_stat_int(attribute)
	elif attribute is String:
		return get_stat_string(attribute)

## This function will return a float value based on the parameter given, 
## which should be an Array[float] type.
func get_stat_float(attribute: Array[float]) -> float:
	return attribute[level - 1]
	
## This function will return an int value based on the parameter given, 
## which should be an Array[int] type.
func get_stat_int(attribute: Array[int]) -> int:
	return attribute[level - 1]

## This function will return an int, or float, based on the attribute's string.
func get_stat_string(attribute: String):
	return ability[attribute][level -1]
