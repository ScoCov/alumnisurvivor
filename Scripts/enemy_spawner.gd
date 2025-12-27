class_name Enemy_Spawner
extends Node

@export var enemy_list: Array[EnemyResource]
@export var player: Student_Entity
@export var difficulty: Dictionary
@export var enemy_container: Node2D

@export_category("Settings")
@export var max_spawns: int = 3
@export var spawn_chance: float = 0.5
@export var enemy_minimum: int = 1
@export var spawn_rate: float = 1
@export var spawn_range: float = 400
@export var spawn_too_close: float = 50

var temp_enemy_entity = preload("res://Entities/Enemies/enemy_entity.tscn")
var current_enemy_count: int = 0

func _process(_delta):
	var enemy_count: int = enemy_container.get_child_count()
	if (enemy_count < enemy_minimum or (enemy_count < max_spawns 
					and randf_range(0,1) < (spawn_chance * _delta)) ):
		_attempt_spawn()
		
func _attempt_spawn():
	var enemy = temp_enemy_entity.instantiate()
	enemy.player = player
	enemy.position = enemy.player.position + _get_range()
	enemy_container.add_child(enemy)
	
func _get_range() -> Vector2:
	var rand_vec:= Vector2(randf_range(-spawn_range,spawn_range), 
							randf_range(-spawn_range,spawn_range))
	if player.position.distance_to(player.position + rand_vec) < spawn_too_close:
		rand_vec = _get_range()
	return rand_vec
