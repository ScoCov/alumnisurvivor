extends Control
class_name DEBUG_PAUSE

@export var game_hud: GameOverlay
@export var debug_player: StudentPlayer

var _is_paused: bool = false: 
	set(value):
		_is_paused = value ## Assign the property the value (bool)
		get_tree().paused = _is_paused ## Pauses or Unpauses Game (bool)
		visible = _is_paused ## Makes Paused Menu Visible
		game_hud.visible = !_is_paused ## Hides Game Hud

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"): ## 'ESC' is the 'pause' action.
		_is_paused = !_is_paused
		populate_info()
		
func populate_info():
	## Poluate Student Information
	var student_info = $'Player Info/Panel/MarginContainer/VBoxContainer'
	student_info.find_child("StudentName").get_child(0).text = debug_player.student.student_name
	student_info.find_child("Primary Strength").get_child(0).text = debug_player.student.primary_skill
	student_info.find_child("Secondary Strength").get_child(0).text = debug_player.student.secondary_skill
	student_info.find_child("Weakness").get_child(0).text = debug_player.student.weakness_skill
	
	## Populate Item Information
	var item_info = $'Item Info/Panel/MarginContainer/VBoxContainer'
	for child: ItemStack in debug_player.item_list.get_children():
		if !item_info.has_node(child.item.item_id): ## If the ItemStack does not exist
			var item_row_label := Label.new()
			var new_icon:= Sprite2D.new()
			new_icon.texture = child.item.image
			new_icon.centered = false
			item_row_label.name = child.item.item_id
			item_row_label.anchors_preset = PRESET_FULL_RECT
			item_row_label.add_child(new_icon)
			item_info.add_child(item_row_label)
			
		item_info.get_node(child.item.item_id).text = str(child) ## Give the label the approriate information.
		
## Resumes Game
func _on_resume_pressed() -> void:
	_is_paused = false

## Closes the Game entirely.
func _on_quit_pressed():
	get_tree().quit()
