extends Control


func _on_button_pressed():
	$SmartPhoneFocus.visible = !$SmartPhoneFocus.visible
	
func back_to_main_menu():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
	
func _on_classroom_1_gui_input(event: InputEvent):
	if event is InputEventMouse and event.is_pressed():
		get_tree().change_scene_to_file("res://Scenes/Maps/Map_Entrance.tscn")
		
func _on_putaway_pressed():
	_on_button_pressed()
