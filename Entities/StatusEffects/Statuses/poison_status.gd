class_name Status_Poison
extends Status_Effect_Entity


func _on_expires():
	entity.modulate = Color(1,1,1,1)

func _on_tick():
	entity.health.attempt_damage(-status_resource.base_value)

func _on_initial_infection():
	entity.modulate = status_color
