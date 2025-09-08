class_name GameLogic
extends Node

#region Description
#endregion

#@export var player: StudentEntity
@export var player: StudentEntity
@export var enemy_spawner: EnemySpawner
@export var spawn_point: Vector2 = Vector2()
@export var game_time: Timer
#@export var experience: ExperienceComponent
@export var canvas_layer: CanvasLayer
		
func _ready() -> void:
	assert(has_node("ProjectileContainer"), "GameLogic must have a Node named ProjectileContainer")
	assert(has_node("EnemySpawner"), "GameLogic must have a node named EnemySpawner [ with associated script].")
	canvas_layer.get_node("GameOverlay").update.emit()
	if game_time != null:
		game_time.timeout.connect(game_over)
	if player.health_state is DeadState:
		game_over()

func hideshow_container_children(container_name: String, _is_paused: bool):
	for child in get_node(container_name).get_children():
		child.visible = _is_paused

func game_over():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
