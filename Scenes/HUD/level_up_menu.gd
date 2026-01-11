class_name Level_Up_Menu
extends Control

signal game_resumed
signal object_chosen
signal reroll
signal ban
signal skip

#@export var rendering_node: Node2D 
@export var game_ui: Game_Ui

@onready var level_up_points = $"Title/Level Up Points"


#region build_note
## NOTE: 
## First thing needed is a set of random items. Eventually, it'll include logic to obtain abilities.
## After there is a list of items obtain, it then needs to assign up to 4 of them, minimum 3, to
## the available options.
## When an item is chosen, decrement the level up points. 
#endregion
	

func _ready():
	pass
	
func _on_skip_pressed():
	skip.emit()
	game_ui.display_game_ui()
	
func update():
	ui_information()

func ui_information():
	level_up_points.text = "+%s" % game_ui.player.experience.level_up_points
	
func randomize_options():
	## Grab random items, eventually with logic
	pass
