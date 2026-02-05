class_name Pause_Menu
extends Control

signal game_paused
signal game_resumed
signal game_quit
signal ready_signal

@export var game_ui: Game_Ui:
	set(value):
		game_ui = value
@onready var stat_block = $StatBlock

func _ready():
	emit_signal("ready_signal")
	
func _on_resume_pressed():
	game_ui.display_game_ui()
	game_resumed.emit()

func _on_quit_pressed():
	game_quit.emit()
	get_tree().quit()

func _on_game_paused():
	stat_block.menu_update()
