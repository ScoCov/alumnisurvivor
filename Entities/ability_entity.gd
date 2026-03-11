class_name Ability_Entity
extends Node2D

#region Development Notes
## This is the base ability entity that will have all the other abilities based upon.
## each form should be an instantiated Ability_Entity.
#endregion
@export_category("Connections")
@export var entity: Entity
@export var ability: Ability_Resource
#@export var damage_comp: Damage_Component
## Assign Nodes and reusable default values.

@export_group("Debug")
@export var debug: bool = true
@export var debug_loop: bool = false
@export var follow_mouse: bool = false
@export var custom_target: Vector2 = Vector2.ZERO

@onready var damage: Damage_Component = $Damage

## This stuff
var entity_pool: Array[Entity]
var target_entity: Entity
## Counters 
var attack_speed_current: float = 0.0
var projectiles_current: int = 0
var bounce_current: int = 0
var look_at_target: bool = true
var enable_attack: bool = false

var _items: Item_Container:
	get():
		if get_parent() is Ability_Manager:
			if get_parent().parent_entity.has_node("Items"):
				return get_parent().parent_entity.items
		return null

func _ready():
	pass
	
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
	return false
	
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

func _get_attribute_value(attribute_id: String) -> float:
	if _items:
		return ability[attribute_id] * (1 + _items.get_attribute_bonus(attribute_id))
	return ability[attribute_id]

## Sorts the entity pool from closest to furthers distance.
func sort_entity_pool():
	if len(entity_pool) > 0:
		if len(entity_pool) > 1:
			entity_pool.sort_custom(func(_entity_a, _entity_b): return get_parent().position.distance_to(_entity_a.position) < get_parent().position.distance_to(_entity_b.position)) 
