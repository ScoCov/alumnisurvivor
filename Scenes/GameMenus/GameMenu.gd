extends Control

func _ready():
	get_tree().paused = false
	
func back_to_main_menu():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
	
func _on_abandoned_classroom_pressed():
	get_tree().change_scene_to_file("res://Scenes/GameMenus/SafePlace/SafePlace.tscn")

func _on_class_room_pressed():
	get_tree().change_scene_to_file("res://Scenes/Maps/Map_Entrance.tscn")
