class_name Status_Haste
extends Status_Effect_Entity

var speed_modification: float:
	get():
		return status_resource.base_value + (status_resource.growth_value * stack_count)
		
func _on_expires():
	entity.modulate = Color(1,1,1,1) #Restore to normal - Will likely replace with effect
	entity.movement_component.speed_modifier -= speed_modification

func _on_initial_infection():
	entity.modulate = status_color
	entity.movement_component.speed_modifier += speed_modification
