class_name Experience_Manager
extends Node

const resource = preload("res://Resources/Data/Attributes/experience_bonus.tres")

signal level_up
signal experience_gained

@export var player: Player_Entity
@export var player_level: int = 1
@export var base_xp_value: float = 10
@export var xp_growth_rate: float = 0.25
@export var current_xp: float = 0.0
@export var xp_multiplier: float = 0
@export var level_up_points: int = 0


var xp_until_level_up: float:
	get():
		return ceil((base_xp_value * (player_level * xp_growth_rate)) + base_xp_value )

func add_experience(amount: float):
	var items_total_bonus = get_parent().items.get_attribute_bonus(resource.id)
	current_xp += amount + (amount * (1 + items_total_bonus))
	while(current_xp >= xp_until_level_up):
		_level_up()
	experience_gained.emit()
	
func _level_up():
	current_xp =  current_xp - xp_until_level_up 
	player_level += 1
	level_up_points += 1
	level_up.emit()
