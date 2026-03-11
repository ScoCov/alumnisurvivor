class_name Spawn_Group
extends Node

signal spawned_group

@export var min_distance_to_player: float = 150
@export var max_distance_to_player: float = 350

var enemy_resource_array: Array[EnemyResource]
var enemy_spawner: Enemy_Spawner
var enemy_container: Node2D
var player: Student_Entity

func _init(_enemy_spawner: Enemy_Spawner, _enemy_container: Node2D, _player: Student_Entity, _enemy_resource_array: Array[EnemyResource]):
	enemy_spawner = _enemy_spawner
	enemy_container = _enemy_container
	player = _player
	enemy_resource_array = _enemy_resource_array

func load_entity(entity_resource: EnemyResource) -> Enemy_Entity:
	var packed_scene: PackedScene = load("res://Entities/Enemies/%s.tscn" 
										% entity_resource.file_name)
	return packed_scene.instantiate()

func spawn_group(_origin: Vector2, spawn_power: float):
	## Filter group to only be of the spawn power and below.
	var filter_group: Array[EnemyResource] = enemy_resource_array.filter(func(entity:EnemyResource): return entity.power_level <= spawn_power)
	#var build_power: int = 0
	filter_group.sort_custom(func(a,b): return a.power_level < b.power_level )
	var spawn_roster: Array[EnemyResource]

	## TODO: BUILD SPAWN ROSTER
	## spawn_roster.append(filter_group[randi_range(0, len(filter_group) -1)])
	## PSEUDO CODE:
	## 1.) Add Entity to roster
	## 2.) Remove entity's power level from spawn_power
	## 3.) Repeat action 1-2 until spawn_power <= 0
	## 4.) Then give each entity a position based around origin.
	## 5.) Spawn each individually (NOTE: add spawn cooldown timer)
	
	## NOTE: As Enemies are added to the pool I could insantiate each entity. 
	## I shouldn't need to check the entity pool as it shoul align with the resource pool.
	## The commeted code below should be everything needed to connect an entity to 
	## the necessary nodes and resources. 
	
	#for enemy: EnemyResource in enemy_resource_array.filter(func(entity:EnemyResource): return entity.power_level <= spawn_power):
		#var new_entity: Enemy_Entity = load_entity(enemy)
		#new_entity.player = player
		#new_entity.position = _get_position_from_origin(origin)
		#new_entity.death.connect(_remove_power.bind(enemy_spawner, new_entity.entity.power_level))
		#enemy_spawner.current_pwer += new_entity.entity.power_level
		#enemy_container.add_child(enemy_spawner)
	spawned_group.emit()

func _get_position(_origin: Vector2) -> Vector2:
	var new_position:= Vector2(randf_range(-max_distance_to_player, max_distance_to_player),randf_range(-max_distance_to_player, max_distance_to_player))
	if (new_position + _origin).distance_squared_to(_origin) <= min_distance_to_player:
		new_position = _get_position(_origin)
	return new_position
	
func _remove_power(spawner, power_level):
	spawner.current_pwer -= power_level
