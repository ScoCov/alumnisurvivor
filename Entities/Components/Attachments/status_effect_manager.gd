
class_name Status_Effect_Manager
extends Node

signal new_status_effect
signal increase_status_effect_count
signal status_expires

var _status_dict: Dictionary

func _add_to_dict(status: Status_Effect_Entity):
	if _status_dict.has(status.status_resource.status_id):
		_status_dict[status.status_resource.status_id] = status
		increase_status_effect_count.emit()
	else:
		var object_to_dict: Dictionary = {status.status_resource.status_id: status}
		_status_dict.assign(object_to_dict)

func get_status_effect(status: Status_Effect_Resource):
	if _status_dict.has(status.status_id):
		return _status_dict[status.status_id]
	return null
	
func add_status_effect(status: Status_Effect_Resource, max_count_limit = null):
	## Check if child (status Effect entity) exists, if not, then add.
	## if it does exist then increase the stack count. 
	if _status_dict.has(status.status_id):
		if _status_dict[status.status_id].stack_count < 2:
			_status_dict[status.status_id].stack_count += 1
			increase_status_effect_count.emit()
	else:
		var load_string: String = "res://Entities/StatusEffects/Statuses/%s_status.tscn" % [status.status_id]
		var load_status_entity: PackedScene = load(load_string)
		var stat_entity: Status_Effect_Entity = load_status_entity.instantiate()
		stat_entity.entity = get_parent()
		stat_entity.status_resource = status
		stat_entity.expires.connect(_remove_from_dict.bind(stat_entity))
		_status_dict.get_or_add(stat_entity.status_resource.status_id, stat_entity)
		add_child(stat_entity)
		new_status_effect.emit()

func _remove_from_dict(status: Status_Effect_Entity):
	if _status_dict.has(status.status_resource.status_id):
		_status_dict.erase(status.status_resource.status_id)
