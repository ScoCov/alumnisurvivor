extends Node2D


func _on_exit_area_body_entered(body):
	if body is StudentEntity:
		## Convert to access a new menu window of some sort.
		$Node2D/Window.visible = true
		$Node2D/Window/Exit/No.grab_focus()
		get_tree().paused = true

func _on_interaction_area_body_entered(body):
	if body is StudentEntity:
		## Convert to a confirmation window of some sort. 
		print("View Collection?:  Y/N?")

func _on_no_pressed():
	$Node2D/Window.visible = false
	get_tree().paused = false

func _on_yes_pressed():
	get_tree().paused = false
	call_deferred("change_to_game_menu")

func change_to_game_menu():
	get_tree().change_scene_to_file("res://Scenes/GameMenus/GameMenu.tscn")
	
