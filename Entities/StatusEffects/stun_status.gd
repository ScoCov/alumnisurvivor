class_name Status_Stun
extends Status_Effect_Entity


func _on_expires():
	entity.modulate = Color(1,1,1,1)
