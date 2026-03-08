class_name Status_Slow
extends Status_Effect_Entity

var speed_modification: float:
	get():
		return status_resource.base_value + (status_resource.growth_value * clamp(stack_count,1, 2)) 


func _on_expires():
	entity.modulate = Color(1,1,1,1) #Restore to normal - Will likely replace with effect
	var temp = entity.movement_component as Enemy_Movement_Component
	entity = entity as Enemy_Entity
	entity.movement_component = entity.movement_component as Enemy_Movement_Component
	entity.movement_component.check_for_slow = false
	#entity.movement_component.speed_modifier += speed_modification
	
func _on_initial_infection():
	entity.modulate = status_color
	entity.movement_component.check_for_slow = true
	var temp = false 
	#entity.movement_component.speed_modifier -= speed_modification

func _on_stack_reduced():
	update_duration(clamp(stack_count, 1, 2)* status_resource.duration) ## Allows the duration to be increased by only 2 stacks maximum
