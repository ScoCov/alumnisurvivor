extends State
class_name PlayerMoving

@export var player: StudentPlayer
const DEFAULT_MOVEMENT_SPEED: float = 100

##	Call when transitioning to this state
func enter():
	pass
	
##	Call when leaving this state
func exit() -> void:
	pass

func update(_delta):
	if player.velocity == Vector2() :
		Transitioned.emit(self, "PlayerIdle")
		
func physics_update(_delta):
	if !player: # Sentinel Check, if no player, exit function with warning.
		assert(player != null, "Player cannot be null.")
		return 
		
	var directions:= Input.get_vector("move_left","move_right","move_up","move_down")
	if player.stats.attributes.has("ATTRIBUTE_MOVEMENT_SPEED"):
		var item_bonuses: float = 0.0
		if player.item_list.attributes.has("ATTRIBUTE_MOVEMENT_SPEED"):
			item_bonuses = player.item_list.attributes["ATTRIBUTE_MOVEMENT_SPEED"]
		var movement_comp := player.stats.attributes["ATTRIBUTE_MOVEMENT_SPEED"] as MovementComponent
		var _value = movement_comp.value * (1 + item_bonuses)
		player.velocity = directions * _value
	player.find_child("Sprite2D").flip_h = true if directions.x > 0 else false
	player.move_and_slide()
		
