@tool
extends Control

const ITEM_NODE_PACKED_SCENE = preload("res://Scenes/HUD/item_node.tscn")

@export var student: Player_Entity:
	set(value):
		student = value
		populate()

@onready var grid_container = $ScrollContainer/MarginContainer/GridContainer

func populate():
	for item_stack: Item_Stack in student.items.get_children():
		var mapping = grid_container.get_children().map(func(e): return e.name)
		var child = mapping.has(item_stack.item.item_name)
		if child: 
			update_node(item_stack)
		else:
			create_node(item_stack)
		
func update_node(item_stack: Item_Stack):
	var item: Item_Resource
	var target_node = grid_container.get_children().find_custom(func(child): return child.item_stack.item.item_id == item_stack.item.item_id)
	if target_node != -1:
		grid_container.get_children()[target_node].item_stack = item_stack
		grid_container.get_children()[target_node].populate_node()

func create_node(item_stack: Item_Stack):
	var item_node = ITEM_NODE_PACKED_SCENE.instantiate()
	item_node.name = item_stack.item.item_name
	item_node.item_stack = item_stack
	grid_container.add_child(item_node)
