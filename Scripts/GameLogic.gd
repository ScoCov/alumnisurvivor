@tool
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
	
func _get_configuration_warnings():
	var msg: Array[String]
	var children = get_children()
	if not children.any(func(child): return child is Enemy_Spawner):
		msg.append("Game Local requires an Enemy Spawner.")
	if not player:
		msg.append("Game Local requires Student Entity.")
	if not game_ui:
		msg.append("Game Local requires Game UI.")
	if not player:
		msg.append("Game Local requires a Student Entity as Player")
	return msg
	
func _ready() -> void:
	player.loaded.connect(student_load)
	player.death.connect(func(): get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn"))
	if game_time != null and not debug:
		game_time.timeout.connect(game_over)

func student_load():
		#player.items.item_count_increased.connect(game_ui.update_health_values)
		game_ui.student_loaded()
		
func debug_mode():
	var thing = $"../Forgound Rendering Node/Test"
	var speed = 15
	var freq = 0.5
	var intensity = 1
	thing.position.x += speed * get_process_delta_time()
	thing.position.y = sin(log(thing.position.x) * freq) * intensity

func game_over():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
	
