class_name GameLogic
extends Node

#region Description
#endregion

#@export var player: StudentEntity
@export var player: StudentEntity
@export var enemy_spawner: EnemySpawner
@export var spawn_point: Node2D
@export var gameTime: Timer

func _ready() -> void:
	assert(has_node("ProjtectileContainer"), "GameLogic must have a Node named ProjectileContainer")
	assert(has_node("EnemySpawner"), "GameLogic must have a node named EnemySpawner [ with associated script].")
	var student_packed_scene = load(Global.SELECTED_STUDENT.scene_path)
	player = student_packed_scene.instantiate()
	if not player: 
		return 
	if player:
		enemy_spawner.player = player
		player.global_projectile_container = enemy_spawner
		var new_camera:= Camera2D.new()
		player.add_child(new_camera)
		spawn_point.add_child(player)
	if gameTime != null:
		gameTime.timeout.connect(func(): get_tree().change_scene_to_file("res://Scenes/GameMenus/GameMenu.tscn"))
