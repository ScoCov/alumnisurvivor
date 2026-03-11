class_name Status_Slow
extends Status_Effect_Entity

var speed_modification: float:
	get():
		return status_resource.base_value + (status_resource.growth_value * clamp(stack_count,1, 2)) 


func _on_expires():
	entity.modulate = Color(1,1,1,1) #Restore to normal - Will likely replace with effect
	entity = entity as Enemy_Entity
	entity.movement_component = entity.movement_component as Enemy_Movement_Component
	entity.movement_component.check_for_slow = false
	
func _on_initial_infection():
	entity.modulate = status_color
	entity.movement_component.check_for_slow = true

func _on_stack_reduced():
	update_duration(clamp(stack_count, 1, 2)* status_resource.duration) ## Allows the duration to be increased by only 2 stacks maximum
