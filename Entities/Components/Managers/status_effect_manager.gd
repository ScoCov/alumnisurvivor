
class_name Status_Effect_Manager
extends Node2D

signal new_status_effect
signal increase_status_effect_count

@export var entity: Entity = get_parent()


var _children: Array[Status_Effect_Entity]:
	set(value):
		pass
	get():
		return get_children().filter(func(child): return child is Status_Effect_Entity)
		
var _status_dict: Dictionary

func _add_to_dict(status: Status_Effect_Entity):
	if _status_dict.has(status.status_resource.status_id):
		_status_dict[status.status_resource.status_id] = status
		increase_status_effect_count.emit()
	else:
		var object_to_dict: Dictionary = {status.status_resource.status_id: status}
		_status_dict.assign(object_to_dict)

## Need to make Depreciated
func get_status_effect(status: Status_Effect_Resource):
	if _status_dict.has(status.status_id):
		return _status_dict[status.status_id]
	return null
	
## Needs to Depreciate
func get_status_effect_dict_by_resource(status: Status_Effect_Resource) -> Dictionary:
	if _status_dict.has(status.status_id):
		return _status_dict[status.status_id]
	return {}
	
func get_status_effect_by_name(status_name: String)-> Status_Effect_Entity:
	var index = _children.rfind_custom(func(child): return child.name.to_lower() == status_name.to_lower())
	if index < 0:
		return null
	return _children[index]
	
func get_status_effect_by_resource(resource: Status_Effect_Resource) -> Status_Effect_Entity:
	var index = _children.rfind_custom(func(child: Status_Effect_Entity): return child.status_resource == resource)
	if index < 0:
		return null
	return _children[index]
	
func get_status_effect_by_id(id: String) -> Status_Effect_Entity:
	var index = _children.rfind_custom(func(child): return child.status_resource.id.to_lower() == id.to_lower())
	if index < 0:
		return null
	return _children[index]

##Needs to be Depreciated
func add_status_effect(status: Status_Effect_Resource, parent_ability: Ability_Entity,  _max_count_limit = null):
	## Check if child (status Effect entity) exists, if not, then add.
	## if it does exist then increase the stack count. 
	if _status_dict.has(status.status_id):
		_status_dict[status.status_id].stack_count += 1
		increase_status_effect_count.emit()
	else:
		var load_string: String = "res://Entities/StatusEffects/Statuses/%s_status.tscn" % [status.status_id]
		var load_status_entity: PackedScene = load(load_string)
		var stat_entity: Status_Effect_Entity = load_status_entity.instantiate()
		stat_entity.entity = entity
		stat_entity.parent_ability = parent_ability
		stat_entity.status_resource = status
		if _max_count_limit:
			stat_entity.max_stack = _max_count_limit
		stat_entity.expires.connect(_remove_from_dict.bind(stat_entity))
		_status_dict.get_or_add(stat_entity.status_resource.status_id, stat_entity)
		add_child(stat_entity)
		new_status_effect.emit()
		
func add_status_effect_entity(status: Status_Effect_Resource, parent_ability: Ability_Entity, _max_count = null): 
	if _children.any(func(child): child.status_resource == status):
		var index = _children.rfind_custom(func(child): return child.status_resource == status)
		var extant_status_effect: Status_Effect_Entity = _children[index]
		## Incrament Status Effect stack Count
		extant_status_effect.stack_count += 1
	else:
		## Add new status entity
		var load_string: String = "res://Entities/StatusEffects/Statuses/%s_status.tscn" % [status.status_id]
		var load_status_entity: PackedScene = load(load_string)
		var stat_entity: Status_Effect_Entity = load_status_entity.instantiate()
		stat_entity.entity = entity
		stat_entity.parent_ability = parent_ability
		stat_entity.status_resource = status
		if _max_count:
			stat_entity.max_stack = _max_count
		stat_entity.expires.connect(_remove_from_dict.bind(stat_entity))
		add_child(stat_entity)
		new_status_effect.emit()
		
func cleanse_status_effect(status: Status_Effect_Entity):
	var index = _children.rfind_custom(func(child): return child == status)
	_children.remove_at(index)

func _remove_from_dict(status: Status_Effect_Entity):
	if _status_dict.has(status.status_resource.status_id):
		_status_dict.erase(status.status_resource.status_id)
