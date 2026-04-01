@tool
extends Control
class_name Game_Ui

signal player_paused
signal player_leveled
signal player_resumed
signal player_death

#region Description
## Game UI controls what is being displayed on the screen at the time the game is actively being played.
## It does nothing and does not exist while in the menu, this is purely control whether or not to show
## the pause menu, the level up menu, or the game and its HUD. 
##
## As a side effect, it also is where we are controlling the game being paused. This is where
## we detected the unhandled_event of the player pressing the pause button (ESC). 
#endregion

@export var player: Player_Entity
@export var game_logic: Game_Local
@export var render_node: Node2D
@export var debug_mode: bool = false

@onready var game_hud: Game_HUD = $"Game HUD"
@onready var level_up_menu: Level_Up_Menu = $LevelUpMenu
@onready var pause_menu: Pause_Menu = $PauseMenu
@onready var death_menu = $"Death Menu"

func _ready():
	player.death.connect(func(): player_death.emit())

func _get_configuration_warnings():
	var msg: Array[String]
	if [game_logic, render_node, player].any(func(prop): return prop == null):
		msg.append("Game UI lacks needed objects. %s" % [["player", "game_logic", "render_node"]])
	return msg
	
func update_health_values():
	game_hud.update_health_values()
	
func _unhandled_input(event):
	if event is InputEventKey and event.is_action_pressed("pause"):
		if pause_menu.visible:
			display_game_ui()
		else:
			display_pause_menu()
 
func student_loaded(): ## I am not understanding load order so using _ready() hasn't worked out. 
	game_hud.update_hud_static()
	player.experience.level_up.connect(display_level_up_menu, 1)
	
	player.experience.experience_gained.connect(game_hud.update_experience_values)
	player.health.damage_taken.connect(game_hud.update_health_values)
	player.health.damage_healed.connect(game_hud.update_health_values)
	pause_menu.game_resumed.connect(display_game_ui)
	level_up_menu.game_resumed.connect(display_game_ui)

func display_level_up_menu():
	level_up_menu.update()
	render_node.visible = false
	game_hud.visible = false
	get_tree().paused = true
	level_up_menu.visible = true
	pause_menu.visible = false
	player_leveled.emit()
	level_up_menu.emit_signal("menu_triggered")

func display_pause_menu():
	render_node.visible = false
	game_hud.visible = false
	get_tree().paused = true
	level_up_menu.visible = false
	pause_menu.visible = true
	player_paused.emit()
	
func display_game_ui():
	get_tree().paused = false
	render_node.visible = true
	game_hud.visible = true
	level_up_menu.visible = false
	pause_menu.visible = false
	player_resumed.emit()
