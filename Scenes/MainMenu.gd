extends Control
#region Description
## This main menu serves basic navigation. Mainly to handle simple tasts that don't require much visuals. 
## This being, Collections to show what has been unlocked. Settings, which will be built later on.
## And, options to quit the game, or go into the 'game' part of the game. 
#endregion

@onready var page = $HSplitContainer/Content/Page


func ready():
	(find_child("Play") as Button).grab_focus()

func _on_quit_pressed():
	get_tree().quit()
	
func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/GameMenus/GameMenu.tscn")

func _on_collection_pressed():
	page.emit_signal("page_type_changed", "Collection")

func _on_settings_pressed():
	page.emit_signal("page_type_changed", "Settings")

