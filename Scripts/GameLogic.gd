class_name Game_Local
extends Node

const PLAYER_ENTITY: PackedScene = preload("res://Entities/player_entity.tscn")

signal loaded

#region Description
## This script is to control the basic functions of the game. Mainly, it should
## act as a repository to find all the various calls being done. 
##
## At first, it will have lots of code litered within it, but eventually it will 
## be a rather small file that is mainly calling 1, or 2 compnents actions.
#endregion

@export var stage_resource: Stage_Resource 
## Pass in the StudentEntity that will be used in the game.
@export var player: Player_Entity
## This is the time limit for the game.
@export var game_time: Timer
@export var enemy_spawner: Enemy_Spawner
@export var game_ui: Game_Ui
@export var reroll_counter: int = 1

func _ready() -> void:
	create_student()
	Global.CURRENT_RUN.current_player_entity = player
	game_ui.update_health_bar.emit()
	player.student_manager.student_swap.connect(hud_student_face_update)
	hud_student_face_update()
	if game_time != null:
		game_time.wait_time = stage_resource.time_limit
		game_time.timeout.connect(stage_end)
		game_time.start()
	loaded.emit()
	
func hud_student_face_update():
	game_ui.swap_students.emit()
	
func create_student():
	if not player:
		player = PLAYER_ENTITY.instantiate()
	player.death.connect(game_over)

func student_load():
	game_ui.student_loaded()
		
func stage_end():
	## Clear Each Container
	Global.CURRENT_RUN.current_stage_number = Global.CURRENT_RUN.current_stage_number + 1
	get_tree().change_scene_to_file("res://Scenes/Maps/school_map.tscn")
	
func clear_projectiles(child: Node2D):
	child.queue_free()

func game_over():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")

func _on_loaded():
	Global.CURRENT_RUN.game_logic = self
