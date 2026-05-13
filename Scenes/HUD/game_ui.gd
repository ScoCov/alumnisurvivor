extends Control
class_name Game_Ui

@warning_ignore("unused_signal")
signal swap_students
@warning_ignore("unused_signal")
signal update_health_bar
@warning_ignore("unused_signal")
signal update_experience_bar

#region Description
## Game UI controls what is being displayed on the screen at the time the game is actively being played.
## It does nothing and does not exist while in the menu, this is purely control whether or not to show
## the pause menu, the level up menu, or the game and its HUD. 
##
## As a side effect, it also is where we are controlling the game being paused. This is where
## we detected the unhandled_event of the player pressing the pause button (ESC). 
#endregion

var player: Player_Entity:
	get():
		return Global.CURRENT_RUN.current_player_entity
var game_logic: Game_Local: 
	get():
		return Global.CURRENT_RUN.game_logic
		
@onready var game_hud: Game_HUD = $"Game HUD"
@onready var pause_menu: Pause_Menu = $PauseMenu

func _ready():
	Global.CURRENT_RUN.experience.experience_gained.connect(game_hud.update_experience_values)

func update_health_values():
	game_hud.update_health_values()
	
func _unhandled_input(event):
	if event is InputEventKey and event.is_action_pressed("pause"):
		if pause_menu.visible:
			display_game_ui()
		else:
			display_pause_menu()
 
func display_pause_menu():
	game_hud.visible = false
	get_tree().paused = true
	pause_menu.visible = true
	
func display_game_ui():
	get_tree().paused = false
	game_hud.visible = true
	pause_menu.visible = false

func _on_swap_students():
	game_hud.update_faces()

func _on_update_experience_bar():
	game_hud.update_experience_values()

func _on_update_health_bar():
	game_hud.update_health_values()
