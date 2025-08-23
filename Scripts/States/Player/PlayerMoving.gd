extends State
class_name PlayerMoving

@export var player: StudentEntity
const DEFAULT_MOVEMENT_SPEED: float = 100

##	Call when transitioning to this state
func enter():
	pass
	
##	Call when leaving this state
func exit() -> void:
	pass

func update(_delta):
	if not Input.get_vector("move_left","move_right","move_up","move_down"):
		Transitioned.emit(self, "PlayerIdle")
		
func physics_update(_delta):
	var directions:= Input.get_vector("move_left","move_right","move_up","move_down")
	if player :
		var adjusted_speed = player.get_node("Composition/MovementSpeed").value
		player.velocity = (directions * (adjusted_speed * _delta)) 
		player.find_child("Sprite").flip_h = true if directions.x > 0 else false
		player.move_and_slide()
		
