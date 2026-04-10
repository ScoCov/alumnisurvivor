class_name Status_Stun
extends Status_Effect_Entity




func _on_expires():
	entity.movment_component.check_for_stun = false

func _on_initial_infection():
	entity.movment_component.check_for_stun = true
