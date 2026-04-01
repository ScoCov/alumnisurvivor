@tool
class_name Enemy_Spawner
extends Node

signal group_spawn ## Triggers when normal enemies spawn
signal mini_boss_spawn ## Triggers when mini-boss spawns
signal boss_spawn ## Triggers when map's boss is spawned
signal spawn_attempt ## Triggers when there should be a spawn attempt
signal power_increased
signal power_decreased

const XP_NODE = preload("res://Entities/xp_node.tscn")
const SPAWN_INDICATOR = preload("res://Scripts/Spawner/spawn_indicator.tscn")

@export_category("Imports")
@export var enemy_list: Array[EnemyResource] ## List of enemies for the given map
@export var player: Player_Entity
@export var enemy_container: Node2D ## The container in which enemies operate.

@export_category("Settings")
@export var max_power: float = 5.0 ## Current max Power allowed
@export_range(0.01,1.0, 0.01) var spawn_chance: float = 0.5 ## Chance to spawn a unit
@export var max_distance_to_player: float = 500 ## Maximum distance an entity can spawn from the player.
@export var min_distance_to_player: float = 250 ## Closest distance an entity can spawn from the player. 

@export_group("Power Increases")
@export var power_growth: float = 1.0 ## How much to increase the power
@export var player_level_power: int = 10 ## This is how much power is increased by for the player's given level.
@export var mini_boss_power: int = 5 ## This is how much a miniboss will increase power, once killed.

var entities_dict: Dictionary  ## List of enemies? Whats the difference between this and Enemy List
var current_pwer: float = 0 ## Current power on the field 
var time_passed: int = 0 ## Time used for calculating how much power should be naturally on the field
var _time_start: float
var _offstage_entities: Array[Enemy_Entity]
@onready var spawn_time: Timer = $'spawn_time'
@onready var power_growth_timer: Timer = $'power_growth'

func _get_configuration_warnings():
	var msg: Array[String]
	if !get_children().any(func(child): return child is Timer and child.name == "spawn_time" and child.auto_start):
		msg.append("Enemy Spawner requires a Timer child named /'spawn_time/' which needs to have auto_start enabled")
	if !get_children().any(func(child): return child is Timer and child.name == "power_growth" and child.auto_start):
		msg.append("Enemy Spawner requires a Timer child name /'power_growth/' which needs to have auto_start enabled")
	return msg
	
func _ready():
	_time_start = Time.get_unix_time_from_system()
	spawn_time.connect("timeout", _on_spawn_timer_timeout)
	power_growth_timer.connect("timeout", _on_power_growth_timer_timeout)
	enemy_factory(15)

func _process(_delta):
	pass

func _on_power_growth_timer_timeout():
	max_power += power_growth
	power_increased.emit()
	
func _on_spawn_timer_timeout():
	spawn_attempt.emit()
	spawn_a_group(entities_to_spawn())
	
func entities_to_spawn() -> Array[Enemy_Entity]:
	var power_difference: int = max_power - current_pwer
	var list_of_spawnable_entities: Array[Enemy_Entity] = _offstage_entities.filter(func(child:Enemy_Entity ): return child.entity.power_level < power_difference)
	var spawnable_list: Array[Enemy_Entity] 
	var power_to_add: int
	for entity in list_of_spawnable_entities:
		spawnable_list.append(entity)
		var remove_at_index = _offstage_entities.find_custom(func(child): return child == entity)
		if remove_at_index > -1:
			_offstage_entities.remove_at(remove_at_index)
			power_to_add += entity.entity.power_level
		if power_to_add >= power_difference:
			break
	#if len(spawnable_list) <= 0:
		#pass
	return spawnable_list

## Should be used to determine what enemies to spwan
func get_enemy_from_roll(roll: float) -> EnemyResource:
	var closest_spawn = entities_dict.values().filter(func(entity): 
								return entity.spawn_chance <= roll)
	closest_spawn.sort_custom(func(a,b): return a.spawn_chance > b.spawn_chance)
	return closest_spawn[0].resource
	
## Create an Insantiated Enemy_Entity. The purpose of which is to add these new entities to the _offstage_entity array
func load_entity(entity: EnemyResource) -> Enemy_Entity:
	return load("res://Entities/Enemies/%s.tscn" % entity.file_name).instantiate()

## Used to attached to an entity so that when they are killed it properly updates the current power in the game.
func _remove_power(spawner,  entity):
	call_deferred("drop_xp", entity)
	spawner.current_pwer -= entity.entity.power_level
	entity.health.current_health = entity.health.maximum_health
	enemy_container.remove_child(entity)
	_offstage_entities.append(entity)
	var check_num_of_offstage = true 
	
func drop_xp( _entity: Enemy_Entity, ):
	var new_node = XP_NODE.instantiate()
	new_node.position = _entity.position
	new_node.xp_value = _entity.entity.xp_per_power * _entity.entity.power_level
	enemy_container.add_child(new_node)

## Provides a Vector2 using ranges from the max_distance_to_player and min_distance_to_player as a means to determines spawns for individualt entity.
func _get_position(_origin: Vector2) -> Vector2:
	var new_position:= Vector2(randf_range(-max_distance_to_player, max_distance_to_player),randf_range(-max_distance_to_player, max_distance_to_player)) + _origin
	var distance_to_player: float = new_position.distance_to(player.position)
	if distance_to_player < min_distance_to_player or distance_to_player > max_distance_to_player:
		new_position = _get_position(_origin)
	return new_position
	
func spawn_a_group(entity_group: Array[Enemy_Entity]):
	if len(entity_group) <= 0:
		return
	## Determine what types of entities should be spawned, based on the current power to maximum power difference. 
	## Large differences should either a strong unit or a group of weaker entities.
	## Small difference should always spawn 1 to 2 weaker entities.
	for entity in entity_group:
		if randf_range(0,1) <= spawn_chance:
			#spawn_entity(entity, _get_position(player.position))
			create_spawn_indicator(entity, _get_position(player.position))
			increase_power(entity.entity.power_level)
			
## I will want to give this the type to spawn and have another function determine the spawn type
func spawn_entity(entity_to_spawn: Enemy_Entity, position: Vector2): 
	entity_to_spawn.position = position
	current_pwer += entity_to_spawn.entity.power_level
	enemy_container.add_child(entity_to_spawn)
	
func increase_power(amount: float):
	current_pwer += amount
	
func create_spawn_indicator(entity_to_spawn: Enemy_Entity, _position: Vector2):
	var indicator = SPAWN_INDICATOR.instantiate()
	indicator.position = _position
	indicator.container = enemy_container
	indicator.entity = entity_to_spawn
	#indicator.entity_spawned.connect(spawn_entity.bind(entity_to_spawn, indicator.position))
	#indicator.entity_spawned.connect(increase_power())
	enemy_container.add_child(indicator)
	
func enemy_factory(amount: int):
	for entity in enemy_list:
		for i in amount:
			var new_entity = load_entity(entity)
			new_entity.player = player
			new_entity.death.connect(_remove_power.bind(self, new_entity))
			_offstage_entities.append(new_entity)
