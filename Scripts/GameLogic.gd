extends Node

#region Description
#endregion

@export var player: StudentPlayer
@export var enemy_spawner: EnemySpawner
@export var gameTime: Timer

func _ready() -> void:
	player.student = Global.SELECTED_STUDENT
	player.besty = Global.SELECTED_BESTY
	if gameTime != null:
		gameTime.timeout.connect(func(): get_tree().change_scene_to_file("res://Scenes/GameMenus/GameMenu.tscn"))
