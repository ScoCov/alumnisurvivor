extends Node
class_name Stats

var attributes: Dictionary

func _ready() -> void:
	for child in get_children():
		if child is Component:
			if !attributes.has(child.attribute.id):
				attributes[child.attribute.id] = child
