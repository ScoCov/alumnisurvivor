extends Movement_State
class_name PlayerMovingState



##	Call when transitioning to this state
func enter():
	pass
	
##	Call when leaving this state
func exit() -> void:
	pass

func update(_delta):
	var directions:= Input.get_vector("move_left","move_right","move_up","move_down")
	if not directions:
		Transitioned.emit(self, "idle")
	var player = movement_comp.entity

	## Animation
	var head: Sprite2D = player.find_child("Head")
	
	if directions.x < 0: ## Head instantly follows the direciton of the player.
		head.flip_h = false
	elif directions.x >= 1:
		head.flip_h = true
	#Face flipping:
	head.find_child("Eyes").flip_h = head.flip_h
	head.find_child("Mouth").flip_h = head.flip_h
	if player.velocity != Vector2(0,0):
		player.find_child("AnimationPlayer").play("walk")
	else:
		player.find_child("AnimationPlayer").stop()
		
		
func physics_update(_delta):
	## Set Speed
	var player = movement_comp.entity
	if player.is_controllable:
		var directions:= Input.get_vector("move_left","move_right","move_up","move_down")
		movement_comp.last_movement_direction = directions
		player.velocity = directions * movement_comp.active_movement_speed * movement_comp.speed_modifier
	elif player.movement_component.is_dash:
		player.velocity = movement_comp.last_movement_direction * movement_comp.active_movement_speed * movement_comp.speed_modifier
	player.move_and_slide()
