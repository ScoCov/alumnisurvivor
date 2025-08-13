extends State
class_name EnemyMoving

@export var enemy: EnemyEntity
@export var player: StudentPlayer

const DEFAULT_MOVEMENT_SPEED: float = 100

##	Call when transitioning to this state
func enter():
	pass
	
##	Call when leaving this state
func exit() -> void:
	pass

func update(_delta):
	if enemy.velocity == Vector2():
		Transitioned.emit(self, "PlayerIdle")
		
func physics_update(_delta):
	if !enemy or !enemy.player: # Sentinel Check, if no player, exit function with warning.
		assert(enemy != null or enemy.player != null, "Enemy/Player cannot be null.")
		 
	enemy.find_child('AnimationPlayer').play("moving")
	var direction = enemy.position.direction_to(enemy.player.position)
	enemy.velocity = direction * enemy.stats.attributes["ATTRIBUTE_MOVEMENT_SPEED"].value
	enemy.move_and_slide()
		
