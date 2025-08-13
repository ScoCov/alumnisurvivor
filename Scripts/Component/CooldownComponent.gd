class_name CooldownComponent
extends Component

const cooldown_attribute = preload("res://Resources/Data/Attributes/Cooldown.tres")

func _init():
	if not attribute:
		attribute = cooldown_attribute
