class_name EnemySpawner
extends Node

## This is the most important thing to add.
@export var player: StudentPlayer
@export var spawn_timer: Timer ## TEST

const ENEMY_MAX_COUNT: int = 10
const ENEMY_ELITE_MAX_COUNT: int = 2
const ENEMY_UNIT_SCENE = preload("res://Entities/EnemyEntity.tscn")
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

## Get this list from the map data.
#var list_of_available_enemies: Array[EnemyResource]

func _ready() -> void:
	#list_of_available_enemies.append(load("res://Resources/Data/Enemies/angry_student.tres"))
	spawn_timer.timeout.connect(spawn_enemy)
	spawn_timer.start()
	spawn_enemy()
	
func spawn_enemy() -> void:
	if ENEMY_MAX_COUNT <= get_child_count():
		return 
	var new_enemy_entity = ENEMY_UNIT_SCENE.instantiate()
	new_enemy_entity.enemy = load("res://Resources/Data/Enemies/angry_student.tres")
	new_enemy_entity.player = player
	new_enemy_entity._spawner_ref = self
	print("Enemy added: %s" % new_enemy_entity.enemy.name)
	#new_enemy_entity.position = new_enemy_entity.get_start_pos( get_rand_vector2(), _min, _max)
	add_child(new_enemy_entity)
#
#func get_start_pos(enemy: EnemyEntity, rand_vector2: Vector2) -> Vector2:
	#var new_vector2 := enemy.player.position + rand_vector2
	#var new_distance := enemy.player.position.distance_to(new_vector2)
	#return (new_vector2 if (new_distance > _min) or (new_distance < _max) 
		#else get_start_pos(enemy, get_rand_vector2()))
#
#func get_rand_vector2(max_dist: float = _max) -> Vector2:
	#return Vector2(randf_range(- max_dist, max_dist), randf_range(-max_dist, max_dist))
