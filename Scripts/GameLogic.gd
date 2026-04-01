class_name Game_Local
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
@export var player: Player_Entity
## This is the time limit for the game.
@export var game_time: Timer
@export var enemy_spawner: Enemy_Spawner
@export var game_ui: Game_Ui
@export var reroll_counter: int = 1
	
func _ready() -> void:
	player.loaded.connect(student_load)
	player.death.connect(func(): get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn"))
	if game_time != null and not debug:
		game_time.timeout.connect(game_over)

func student_load():
	game_ui.student_loaded()
		
func game_over():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
	
