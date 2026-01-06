class_name Enemy_Spawner
extends Node

@export_category("Imports")
@export var enemy_list: Array[EnemyResource]
@export var player: Student_Entity
@export var enemy_container: Node2D

@export_category("Settings")
@export var min_power: int = 1
@export var max_power: float = 10.0
@export var power_growth: float = 1.0

@export var spawn_chance: float = 0.5
@export var spawn_rate: int = 1
@export var growth_rate: int = 1000
@export var max_distance_to_player: float = 400
@export var min_distance_to_player: float = 150

var spawn_pwr: float:
	get():
		return (max_power * 0.25)

var spawn_group: Spawn_Group
var entities_dict: Dictionary 
var current_pwer: float = 0
var time_passed: int = 0

func _ready():
	spawn_group = Spawn_Group.new(self, enemy_container, player, enemy_list)
	collect_spawnable()

func _process(_delta):
	time_passed += 1
	$"../../CanvasLayer/game_ui/Label".text = "Current Power Level: %s/%s | Spawn Rate: %s" % [current_pwer, max_power, spawn_rate]
	## Check to see if max or min count of enemy entities as been exceeded.
	if time_passed % growth_rate == 0:
		max_power += 1
		if time_passed % int(max_power) == 0:
			spawn_rate -= 1
	if should_spawn(current_pwer):
		#spawn_group.spawn_group(player.position,1)
		_spawn_entity() ## Spawn enemy

func should_spawn(power_level) -> bool:
	var true_conditions = [(power_level < min_power),( current_pwer < max_power and randf_range(0,1) <= spawn_chance)]
	return (time_passed % spawn_rate == 0) and true_conditions.any(func(check): return check == true)

func get_enemy_from_roll(roll: float) -> EnemyResource:
	var closest_spawn = entities_dict.values().filter(func(entity): 
								return entity.spawn_chance <= roll)
	closest_spawn.sort_custom(func(a,b): return a.spawn_chance > b.spawn_chance)
	return closest_spawn[0].resource
	
func load_entity(entity: EnemyResource) -> Enemy_Entity:
	return load("res://Entities/Enemies/%s.tscn" % entity.file_name).instantiate()
	
func _spawn_entity():
	var entity: Enemy_Entity = load_entity(get_enemy_from_roll(randf_range(0,1)))
	entity.player = player
	entity.position = entity.player.position + _get_position(entity.player.position)
	entity.death.connect(_remove_power.bind(self, entity.entity.power_level))
	current_pwer += entity.entity.power_level
	enemy_container.add_child(entity)
	
func _remove_power(spawner, power_level):
	spawner.current_pwer -= power_level

func _get_range(_origin: Vector2) -> Vector2:
	var new_position_offset: Vector2 = Vector2(randf_range(-max_distance_to_player, max_distance_to_player),randf_range(-max_distance_to_player, max_distance_to_player))
	if new_position_offset.distance_to(player.position) <= min_distance_to_player:
		return _get_range(_origin)
	return _origin + new_position_offset
	
func _get_position(_origin: Vector2) -> Vector2:
	var new_position:= Vector2(randf_range(-max_distance_to_player, max_distance_to_player),randf_range(-max_distance_to_player, max_distance_to_player))
	if (new_position + _origin).distance_squared_to(_origin) <= min_distance_to_player:
		new_position = _get_position(_origin)
	return new_position
	
func collect_spawnable():
	entities_dict = {}
	for entity in enemy_list:
		## Convert entity into dictionary
		var entity_to_add: Dictionary = {
			"name": entity.name, 
			"spawn_chance": 1 - (1.0 / entity.power_level),  
			"resource": entity
			}
		entities_dict.get_or_add(entity.name.to_lower(), entity_to_add)
