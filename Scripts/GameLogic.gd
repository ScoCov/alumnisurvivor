class_name GameLogic
extends Node

#region Description
#endregion

#@export var player: StudentEntity
@export var player: StudentEntity
@export var enemy_spawner: EnemySpawner
@export var spawn_point: Vector2 = Vector2()
@export var gameTime: Timer
@export var experience: ExperienceComponent
@export var canvas_layer: CanvasLayer
		
func _ready() -> void:
	assert(has_node("ProjectileContainer"), "GameLogic must have a Node named ProjectileContainer")
	assert(has_node("EnemySpawner"), "GameLogic must have a node named EnemySpawner [ with associated script].")
	var student_packed_scene = load(Global.SELECTED_STUDENT.scene_path)
	player = student_packed_scene.instantiate()
	canvas_layer.get_node("GameOverlay").player = player
	canvas_layer.get_node("LevelUp").player = player
	enemy_spawner.player = player
	player.global_projectile_container = enemy_spawner
	var new_camera:= Camera2D.new()
	player.add_child(new_camera)
	player.position = spawn_point
	get_node("Player").add_child(player)
	if gameTime != null:
		gameTime.timeout.connect(func(): get_tree().change_scene_to_file("res://Scenes/GameMenus/GameMenu.tscn"))

func hideshow_container_children(container_name: String, _is_paused: bool):
	for child in get_node(container_name).get_children():
		child.visible = _is_paused

func level_up():
	pass
