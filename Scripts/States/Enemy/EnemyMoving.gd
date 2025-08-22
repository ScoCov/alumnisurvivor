extends State
class_name EnemyMoving

@export var enemy: EnemyEntity

const DEFAULT_MOVEMENT_SPEED: float = 100

##	Call when transitioning to this state
func enter():
	pass
	
##	Call when leaving this state
func exit() -> void:
	pass

func update(_delta):
	if enemy.velocity == Vector2() or not enemy.player:
		Transitioned.emit(self, "EnemyIdle")
		
func physics_update(_delta):
	if not enemy.player:
		return # Sentinel Check, if no player, exit function with warning.
	var direction = enemy.position.direction_to(enemy.player.get_parent().position + enemy.player.position) 
	enemy.velocity = (direction * $"../../Stats/MovementSpeed".value if $"../../Stats/MovementSpeed" else DEFAULT_MOVEMENT_SPEED )
	enemy.move_and_slide()
		
