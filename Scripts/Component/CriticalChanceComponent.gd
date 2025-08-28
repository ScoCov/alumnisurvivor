class_name CriticalChanceComponent
extends Component

const crticial_chance_attribute = preload("res://Resources/Data/Attributes/CriticalChance.tres")


func _init():
	if not attribute:
		attribute = crticial_chance_attribute
