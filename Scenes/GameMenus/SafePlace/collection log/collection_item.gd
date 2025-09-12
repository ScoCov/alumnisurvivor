class_name CollectionItem
extends Control

@export var item: ItemResource 

func _ready():
	if item:
		$Control/Sprite2D.texture = item.image
		$Itemname.text = "%s" % item.item_name
