extends Control

@export var game_hud: GameOverlay
@export var game_logic: GameLogic

var _is_paused: bool = false: 
	set(value):
		_is_paused = value ## Assign the property the value (bool)
		get_tree().paused = _is_paused ## Pauses or Unpauses Game (bool)
		visible = _is_paused ## Makes Paused Menu Visible
		if game_hud:
			game_hud.visible = !_is_paused ## Hides Game Hud
		if game_logic: ## Hide parts of the game
			$PauseStats.player = game_logic.player
			$PauseStats.update()
			game_logic.hideshow_container_children("EnemySpawner", !_is_paused)
			game_logic.hideshow_container_children("ExperienceContainer", !_is_paused)
			game_logic.hideshow_container_children("ProjectileContainer", !_is_paused)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"): ## 'ESC' is the 'pause' action.
		_is_paused = !_is_paused
		
		
## Resumes Game
func _on_resume_pressed() -> void:
	_is_paused = false

## Closes the Game entirely.
func _on_quit_pressed():
	get_tree().quit()

func _on_main_menu_pressed():
	_is_paused = false
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
