@tool
class_name Entity
extends CharacterBody2D

var status_effects: Node2D
var health: Health_Component

func _get_configuration_warnings():
	var return_array: Array[String]
	if not get_children().any(func(child): child is Health_Component):	
		return_array.append("Entity Requires a Health Component")
	if not get_children().any(func(child): child.name.to_lower() == "statuseffects"):
		return_array.append("Entity requires a Node2D name 'StatusEffects'.")
	return return_array

func _get_health_component():
	health = get_child(get_children().find_custom(func(child): return child is Health_Component))
	
func _get_status_effect_component():
	status_effects = get_child(get_children().find_custom(func(child): return child.name.to_lower() == "statuseffects"))

func get_universal_components():
	_get_health_component()
	_get_status_effect_component()
