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
@export var spawn_range_minimum: float = -50
@export var spawn_range_maximum: float = 50
@export var too_close:= Vector2(50,50)

var temp_enemy_entity = preload("res://Entities/Enemies/enemy_entity.tscn")
var current_enemy_count: int = 0

func _process(_delta):
	if enemy_container.get_child_count() < 1:
		_attempt_spawn()
	else:
		if enemy_container.get_child_count() < max_spawns:
			if randf_range(0,1) < (spawn_chance * _delta):
				_attempt_spawn()
		

func _attempt_spawn():
	var rand_x: float = randf_range(spawn_range_minimum,spawn_range_maximum)
	var rand_y: float = randf_range(spawn_range_minimum,spawn_range_maximum)
	var enemy = temp_enemy_entity.instantiate()
	enemy.player = player
	enemy.position = player.position + Vector2(rand_x, rand_y)
	enemy_container.add_child(enemy)
	
func _get_range() -> Vector2:
	var rand_x: float = randf_range(spawn_range_minimum,spawn_range_maximum)
	var rand_y: float = randf_range(spawn_range_minimum,spawn_range_maximum)
	var rand_vec:= Vector2(rand_x, rand_y)
	if rand_vec < too_close:
		rand_vec = _get_range()
	return rand_vec
