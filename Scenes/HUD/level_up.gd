extends Control

signal leveled_up

@export var game_hud: GameOverlay
@export var game_logic: GameLogic
@export var player: StudentEntity

var item: ItemResource

var _is_paused: bool:
	set(value):
		visible = value
		get_tree().paused = value
	
func _process(delta): ## This won't start processing until the game is paused.
	_is_paused = get_tree().paused
	$Continue.disabled = item == null
	for item_card in $Panel/MarginContainer/HBoxContainer.get_children():
		if item_card.has_focus():
			item = item_card.item
	
func visibility_change(is_paused: bool):
	if player and not is_paused:
		$Panel/Label.text = "Congratulations, %s! You are now level %s!" % [player.student.student_name, player.experience.level]
	if game_hud:
		game_hud.visible = !is_paused ## Hides Game Hud
	if game_logic: ## Hide parts of the game
		game_logic.hideshow_container_children("EnemySpawner", !is_paused)
		game_logic.hideshow_container_children("ExperienceContainer", !is_paused)
		game_logic.hideshow_container_children("ProjectileContainer", !is_paused)
	$Panel/MarginContainer/HBoxContainer.get_node("ItemCard").item = Global.ITEM_COLLECTION[randi_range(0, len(Global.ITEM_COLLECTION) -1)]
	$Panel/MarginContainer/HBoxContainer.get_node("ItemCard2").item = Global.ITEM_COLLECTION[randi_range(0, len(Global.ITEM_COLLECTION) -1)]
	$Panel/MarginContainer/HBoxContainer.get_node("ItemCard3").item = Global.ITEM_COLLECTION[randi_range(0, len(Global.ITEM_COLLECTION) -1)]
	$Panel/MarginContainer/HBoxContainer.get_node("ItemCard4").item = Global.ITEM_COLLECTION[randi_range(0, len(Global.ITEM_COLLECTION) -1)]
	$Panel/MarginContainer/HBoxContainer.get_node("ItemCard4").visible = false if randf_range(0,1) < 0.5 else true
		
func _on_button_pressed():
	player.items.add_item(item)
	item = null
	_is_paused = false

func _on_visibility_changed():
	visibility_change(_is_paused)


func _on_focus_entered():
	pass # Replace with function body.


func _on_focus_exited():
	pass # Replace with function body.
