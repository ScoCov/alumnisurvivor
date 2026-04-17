class_name Enemy_Spawner
extends Node

#signal group_spawn ## Triggers when normal enemies spawn
#signal mini_boss_spawn ## Triggers when mini-boss spawns
#signal boss_spawn ## Triggers when map's boss is spawned
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
@export var max_number_of_entities: int = 10 ## Currently Unused
@export var max_power: float = 5.0 ## Current max Power allowed
@export_range(0.01,1.0, 0.01) var spawn_chance: float = 0.5 ## Chance to spawn a unit
@export var max_distance_to_player: float = 500 ## Maximum distance an entity can spawn from the player.
@export var min_distance_to_player: float = 250 ## Closest distance an entity can spawn from the player. 

@export_group("Power Increases")
@export var power_growth: float = 1.0 ## How much to increase the power
@export var player_level_power: int = 2 ## This is how much power is increased by for the player's given level.
@export var mini_boss_power: int = 5 ## This is how much a miniboss will increase power, once killed.

@export_group("Debug")
@export var enemy_population_amount: int = 5

var entities_dict: Dictionary  ## List of enemies? Whats the difference between this and Enemy List
var current_pwer: float = 0 ## Current power on the field 
var time_passed: int = 0 ## Time used for calculating how much power should be naturally on the field
var _time_start: float

@onready var spawn_time: Timer = $'spawn_time'
@onready var power_growth_timer: Timer = $'power_growth'

func _ready():
	_time_start = Time.get_unix_time_from_system()
	spawn_time.connect("timeout", _on_spawn_timer_timeout)
	power_growth_timer.connect("timeout", _on_power_growth_timer_timeout)

func _process(_delta):
	pass

func _on_power_growth_timer_timeout():
	max_power += power_growth
	power_increased.emit()
	
func _on_spawn_timer_timeout():
	spawn_attempt.emit()
	spawn_a_group(grab_entities_to_spawn())

func grab_entities_to_spawn() -> Array[Enemy_Entity]:
	var _entities_capable_of_spawning = enemy_list.filter(func(ent: EnemyResource): return ent.minimum_spawn_power_needed < max_power)
	var power_difference = max_power - current_pwer
	var array_to_return: Array[Enemy_Entity]
	_entities_capable_of_spawning.filter(func(ent: EnemyResource): return ent.power_level < power_difference)
	var current_power_to_spawn: int = 0
	if (len(_entities_capable_of_spawning) > 0):
		while (current_power_to_spawn < power_difference):
			var entity_to_spawn:Enemy_Entity = load_entity(_entities_capable_of_spawning[randi_range(0, len(_entities_capable_of_spawning) - 1)])
			array_to_return.append(entity_to_spawn)
			current_power_to_spawn += entity_to_spawn.entity.power_level
	return array_to_return
	
	
## Create an Insantiated Enemy_Entity. The purpose of which is to add these new entities to the _offstage_entity array
func load_entity(entity: EnemyResource) -> Enemy_Entity:
	var _entity: Enemy_Entity = load("res://Entities/Enemies/%s.tscn" % entity.file_name).instantiate()
	_entity.player = player
	#if !_entity.death.is_connected(_remove_power(self, _entity)):
	_entity.death.connect(_remove_power.bind(self, _entity))
	return _entity

## Used to attached to an entity so that when they are killed it properly updates the current power in the game.
func _remove_power(spawner,  entity):
	call_deferred("drop_xp", entity)
	spawner.current_pwer -= entity.entity.power_level
	power_decreased.emit()
	entity.queue_free()
		
func drop_xp( _entity: Enemy_Entity):
	var new_node = XP_NODE.instantiate()
	new_node.position = _entity.position
	new_node.xp_value = _entity.entity.xp_per_power
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
	if randf_range(0,1) <= spawn_chance:
		var entity  = entity_group[randi_range(0, len(entity_group) -1)]
		create_spawn_indicator(entity, _get_position(player.position))
		increase_power(entity.entity.power_level)
			
func increase_power(amount: float):
	current_pwer += amount
	
func create_spawn_indicator(entity_to_spawn: Enemy_Entity, _position: Vector2):
	var indicator = SPAWN_INDICATOR.instantiate()
	indicator.position = _position
	indicator.container = enemy_container
	indicator.entity = entity_to_spawn
	enemy_container.add_child(indicator)
	
