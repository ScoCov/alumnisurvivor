class_name Entity
extends CharacterBody2D

var status_effects: Status_Effect_Manager

var health: Health_Component

func _get_configuration_warnings():
	var return_array: Array[String]
	if not get_children().any(func(child): return child is Health_Component):	
		return_array.append("Entity Requires a Health Component")
	if not get_children().any(func(child): return child is Status_Effect_Manager):
		return_array.append("Entity requires Status Effect Manager.")
	return return_array

func _get_health_component():
	health = get_child(get_children().find_custom(func(child): return child is Health_Component))
	
func _get_status_effect_component():
	status_effects = get_child(get_children().find_custom(func(child): return child.name.to_lower() in ["statuseffects"]))

func get_universal_components():
	_get_health_component()
	_get_status_effect_component()
