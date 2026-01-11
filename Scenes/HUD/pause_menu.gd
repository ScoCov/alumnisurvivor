class_name Pause_Menu
extends Control

signal game_paused
signal game_resumed
signal game_quit

@export var game_ui: Game_Ui

func _on_resume_pressed():
	game_ui.display_game_ui()
	game_resumed.emit()

func _on_quit_pressed():
	game_quit.emit()
	get_tree().quit()
