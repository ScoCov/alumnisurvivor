class_name Enemy_Movement_Component
extends Node

@export var movement_speed: float = 85
@export var enemy_entity: Enemy_Entity

var movement_strategy: EnemyMovementStrategy.type = EnemyMovementStrategy.type.Move_to_Player:
	set(value):
		movement_strategy = value
		movement_update()
		
var movement_type: EnemyMovementStrategy

func _ready():
	movement_strategy = enemy_entity.movement_strategy
	movement_update()
	
func _process(_delta):
	if not movement_type:
		movement_strategy = enemy_entity.movement_strategy
		movement_update()
	#enemy_entity.find_child("Label").text = "%s (%s)" % [$StateMachine/EnemyMoving/EnemyMovementWanderAggressive/StateMachine.current_state.name, enemy_entity.position.distance_to(enemy_entity.player.position)]
		
func movement_update():
	match movement_strategy:
		EnemyMovementStrategy.type.Move_to_Player:
			movement_type = $StateMachine/EnemyMoving/EnemyMovementToPlayer
		EnemyMovementStrategy.type.Avoid_Player:
			movement_type = $StateMachine/EnemyMoving/EnemyMovementAvoidPlayer
		EnemyMovementStrategy.type.Wander_Ignore:
			movement_type = $StateMachine/EnemyMoving/EnemyMovementWanderIgnore
		EnemyMovementStrategy.type.Wander_Aggressive:
			movement_type = $StateMachine/EnemyMoving/EnemyMovementWanderAggressive
