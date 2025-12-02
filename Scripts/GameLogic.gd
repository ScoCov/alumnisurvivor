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
@export var player: Student_Entity
## This is the time limit for the game.
@export var game_time: Timer
	
func _ready() -> void:
	player.student = Global.SELECTED_STUDENT
	if game_time != null and not debug:
		game_time.timeout.connect(game_over)
		
		
func debug_mode():
	var thing = $"../Forgound Rendering Node/Test"
	var speed = 15
	var freq = 0.5
	var intensity = 1
	thing.position.x += speed * get_process_delta_time()
	thing.position.y = sin(log(thing.position.x) * freq) * intensity

func game_over():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
