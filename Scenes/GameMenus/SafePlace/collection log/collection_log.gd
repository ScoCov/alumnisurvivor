extends Control

const collection_item_scene = preload("res://Scenes/GameMenus/SafePlace/collection log/collection_item.tscn")
@onready var grid_container = $MarginContainer/ScrollContainer/GridContainer


func _ready():
	for item: ItemResource in Global.ITEM_COLLECTION:
		var new_collection_item: CollectionItem = collection_item_scene.instantiate()
		new_collection_item.item = item
		grid_container.add_child(new_collection_item)
