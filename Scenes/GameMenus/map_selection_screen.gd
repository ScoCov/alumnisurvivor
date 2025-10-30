extends Control

const MAP_DESCRIPTION_CARD_PACKED_SCENE:= preload("res://Scenes/GameMenus/map_description_card.tscn")

@onready var maps = $Control/MarginContainer/ScrollContainer/Maps

func _ready():
	populate_map_list()

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/GameMenus/besty_selection_screen.tscn")

func populate_map_list():
	for map in Global.MAPS:
		var new_map_card:= MAP_DESCRIPTION_CARD_PACKED_SCENE.instantiate()
		new_map_card.map = map
		maps.add_child(new_map_card)
