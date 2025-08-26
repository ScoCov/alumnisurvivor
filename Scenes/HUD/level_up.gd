extends Control

signal leveled_up

@export var game_hud: GameOverlay
@export var game_logic: GameLogic
@export var player: StudentEntity

var _is_paused: bool:
	set(value):
		visible = value
		get_tree().paused = value
	
func _process(delta): ## This won't start processing until the game is paused.
	_is_paused = get_tree().paused
	
func visibility_change(is_paused: bool):
	if player and not is_paused:
		$Panel/Label.text = "Congratulations, %s! You are now level %s!" % [player.student.student_name, player.experience.level]
	if game_hud:
		game_hud.visible = !is_paused ## Hides Game Hud
	if game_logic: ## Hide parts of the game
		game_logic.hideshow_container_children("EnemySpawner", !is_paused)
		game_logic.hideshow_container_children("ExperienceContainer", !is_paused)
		game_logic.hideshow_container_children("ProjectileContainer", !is_paused)
		$Panel/MarginContainer/HBoxContainer/Upgrade1.get_child(0).text = Global.ITEM_COLLECTION[0].item_name
		$Panel/MarginContainer/HBoxContainer/Upgrade2.get_child(0).text = Global.ITEM_COLLECTION[1].item_name
		$Panel/MarginContainer/HBoxContainer/Upgrade3.get_child(0).text = Global.ITEM_COLLECTION[2].item_name
		$Panel/MarginContainer/HBoxContainer/Upgrade1.get_child(1).texture = Global.ITEM_COLLECTION[0].image
		$Panel/MarginContainer/HBoxContainer/Upgrade2.get_child(1).texture = Global.ITEM_COLLECTION[1].image
		$Panel/MarginContainer/HBoxContainer/Upgrade3.get_child(1).texture = Global.ITEM_COLLECTION[2].image
func _on_button_pressed():
	_is_paused = false

func _on_visibility_changed():
	visibility_change(_is_paused)
