extends Node

## This is the most important thing to add.
@export var player: StudentPlayer
@export var spawn_timer: Timer ## TEST

const ENEMY_MAX_COUNT: int = 1
const ENEMY_ELITE_MAX_COUNT: int = 2
const ENEMY_UNIT_SCENE = preload("res://Entities/EnemyUnit.tscn")

## Get this list from the map data.
var list_of_available_enemies: Array[EnemyBase]

func _ready() -> void:
	list_of_available_enemies.append(load("res://Resources/Data/Enemies/DebugEnemy.tres"))
	spawn_timer.timeout.connect(spawn_enemy)
	spawn_timer.start()
	spawn_enemy()
	pass
	## Grab the enemies that can be spawned from the map details 
	## and assign them to the list of available enmies.
	## NOTE: This will need to be more robust - so that I can break down the list by
	## the enemy type and create spawn rates that are more accurate for those specific types.
	## as of right now, the types I imagine: "Fodder", "Normal", "Strong", "GlassCannon", 
	## "Speedy", and "Elite". This list will likely change in the future.


func _process(_delta) -> void:
	pass
	
func _physics_process(_delta):
	pass
	
func spawn_enemy() -> void:
	if ENEMY_MAX_COUNT <= get_child_count():
		return
	var new_enemy_entity = ENEMY_UNIT_SCENE.instantiate()
	new_enemy_entity.enemy = list_of_available_enemies[0]
	new_enemy_entity.player = player
	new_enemy_entity.position = player.position + Vector2(75,75)
	add_child(new_enemy_entity)
