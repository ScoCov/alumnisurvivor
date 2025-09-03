class_name ArmorComponent
extends Component

const armor_scene = preload("res://Resources/Data/Attributes/Armor.tres")

func _init() -> void:
	if not attribute:
		attribute = armor_scene
