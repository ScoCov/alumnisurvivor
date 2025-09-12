extends Node2D


func _on_exit_area_body_entered(body):
	if body is StudentEntity:
		## Convert to access a new menu window of some sort.
		$Node2D/Exit.visible = true
		$Node2D/Exit/Exit/No.grab_focus()
		get_tree().paused = true

func _on_interaction_area_body_entered(body):
	if body is StudentEntity:
		$Node2D/CollectionLog.visible = true
		get_tree().paused = true

func _on_no_pressed():
	$Node2D/Exit.visible = false
	get_tree().paused = false

func _on_yes_pressed():
	get_tree().paused = false
	call_deferred("change_to_game_menu")

func change_to_game_menu():
	get_tree().change_scene_to_file("res://Scenes/GameMenus/GameMenu.tscn")
	

func _on_collection_log_close_requested():
	$Node2D/CollectionLog.visible = false
	get_tree().paused = false
