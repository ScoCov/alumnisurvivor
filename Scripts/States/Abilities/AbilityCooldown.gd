extends State
class_name AbilityStateCooldown

@export var ability: Ability
@onready var player: StudentPlayer = ability.player_student
@export var timer: Timer
var action: Callable

##	Call when transitioning to this state
func enter():
	#print("Entering: Cooldown")
	var bonus_cooldown = 1
	if ability.has_node("Stats"):
		timer.wait_time = ability.get_node("Stats").get_node("Cooldown").value
		if player.item_list.attributes.has("ATTRIBUTE_COOLDOWN"):
			player.item_list.attributes["ATTRIBUTE_COOLDOWN"] * player.item_list.attributes["ATTRIBUTE_COOLDOWN"]
	if timer:
		if not timer.timeout.is_connected(triggered_event):
			timer.timeout.connect(triggered_event)
			
		timer.start()
	
##	Call when leaving this state
func exit() -> void:
	pass

##	Call every frame drawn
func update(_delta) -> void:
	pass
	
##	Call every physics tick which can be seperate from the frames being drawn.
func physics_update(_delta)-> void:
	pass

func triggered_event(): 
	Transitioned.emit(self, "AbilityReady")
