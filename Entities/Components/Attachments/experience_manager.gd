class_name Experience_Manager
extends Node

signal level_up
signal experience_gained

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
	experience_gained.emit()
	current_xp += amount + (amount * xp_multiplier)
	while(current_xp >= xp_until_level_up):
		_level_up()
	
func _level_up():
	level_up.emit()
	current_xp =  current_xp - xp_until_level_up 
	player_level += 1
	level_up_points += 1
