extends State
class_name PlayerMovingState

@export var player: StudentEntity

const DEFAULT_MOVEMENT_SPEED: float = 100

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

	## Animation
	var head: Sprite2D = player.find_child("Head")
	var body: Sprite2D = player.find_child("StudentBody")
	
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
	var directions:= Input.get_vector("move_left","move_right","move_up","move_down")
	## Set Speed
	player.velocity = directions * player.movement.movement_speed
	player.move_and_slide()
	
