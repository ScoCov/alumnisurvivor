@tool
extends Control

signal loaded

@export var item_stack: Item_Stack
@export var debug_item: Item_Resource

@onready var rich_text_label = $Count_Margin/RichTextLabel
@onready var sprite_2d = $MarginContainer/CenterContainer/Sprite2D

func _make_custom_tooltip(for_text):
	var item_node_tooltip = load("res://Scenes/HUD/item_node_tooltip_custom.tscn")
	var tool_tip = item_node_tooltip.instantiate()
	tool_tip.item = debug_item if not item_stack else item_stack.item
	tool_tip.count = 1 if not item_stack else item_stack.count
	return tool_tip

func _ready():
	loaded.emit()

func populate_node():
	var item: Item_Resource
	if debug_item and not item_stack:
		item = debug_item
		sprite_2d.texture = debug_item.image
		rich_text_label.text = "X1" 
	elif item_stack:
		item = item_stack.item
		sprite_2d.texture = item_stack.item.image
		rich_text_label.text = "X%s" % item_stack.count

func _on_loaded():
	populate_node()
