class_name GameLogic
extends Node

#region Description
## This script is to control the basic functions of the game. Mainly, it should
## act as a repository to find all the various calls being done. 
##
## At first, it will have lots of code litered within it, but eventually it will 
## be a rather small file that is mainly calling 1, or 2 compnents actions.
#endregion

## Check to enter debug mode. Debug mode will disable checks and enable cheats
## to allow better testing. 
@export var debug: bool = false

## Pass in the StudentEntity that will be used in the game.
@export var player: StudentEntity
## This is the time limit for the game.
@export var game_time: Timer
## When the player, enemy, or any other source launches a projectile of any kind;
## it will be placed into this container for better management. 
@export var protectile_container: Node2D
## When experience nodes are dropped by any means, they will be placed into this node.
@export var experience_container: Node2D
## If Consumables appear, they will go into this node container.
@export var consumables_container: Node2D
	

func _ready() -> void:
	player.student = Global.SELECTED_STUDENT
	if game_time != null:
		game_time.timeout.connect(game_over)

func hideshow_container_children(container_name: String, _is_paused: bool):
	for child in get_node(container_name).get_children():
		child.visible = _is_paused

func game_over():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
