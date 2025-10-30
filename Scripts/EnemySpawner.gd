class_name EnemySpawner
extends Node

## This is the most important thing to add.
@export var player: StudentEntity
@export var spawn_timer: Timer ## TEST
@export var global_projectile_container: Node ## Easy way to pass this object down to Abiltiies so when they spawn objects they are independent of the user.

const ENEMY_MAX_COUNT: int = 30
const ENEMY_ELITE_MAX_COUNT: int = 2
#const ENEMY_UNIT_SCENE = preload("res://Entities/EnemyEntity.tscn")
const ENEMY_SPAWN_DISTANCE_MAX: float = 400
@warning_ignore("unused_private_class_variable")
var _max: float:
	set(value):
		pass
	get:
		return ENEMY_SPAWN_DISTANCE_MAX
const ENEMY_SPAWN_DISTANCE_MIN: float = 100
@warning_ignore("unused_private_class_variable")
var _min: float:
	set(value):
		pass
	get:
		return ENEMY_SPAWN_DISTANCE_MIN

@export var experience_container_ref: Node

## Get this list from the map data.
var list_of_available_enemies: Array[EnemyResource] = Global.ENEMY_ROSTER
var loaded_enemies: Array[PackedScene]

func _ready() -> void:
	#spawn_timer.timeout.connect(spawn_enemy)
	spawn_timer.start()
	
func spawn_enemy() -> void:
	if ENEMY_MAX_COUNT <= get_child_count():
		return 
	## TODO: I need to create the logic for determining what kind of enemy to spawn.
	var rand_index: int = randi_range(0,len(list_of_available_enemies) - 1 )
	var new_enemy_scene = load(list_of_available_enemies[rand_index].enemy_scene_path)
	var new_enemy_entity: EnemyEntity = new_enemy_scene.instantiate()
	new_enemy_entity.global_projectile_container = global_projectile_container
	new_enemy_entity.player = player
	new_enemy_entity.spawner_ref = self
	new_enemy_entity.position = get_position()
	add_child(new_enemy_entity)
	
func get_position():
	var new_position = (player.position) + Vector2(randf_range(-ENEMY_SPAWN_DISTANCE_MAX,
														ENEMY_SPAWN_DISTANCE_MAX), 
													randf_range(-ENEMY_SPAWN_DISTANCE_MAX,
														ENEMY_SPAWN_DISTANCE_MAX))
	if player.position.distance_to(new_position) <= 300:
		get_position()
	
	return new_position
