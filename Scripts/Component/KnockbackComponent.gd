class_name KnockbackComponent
extends Component

const knockback_attribute = preload("res://Resources/Data/Attributes/Knockback.tres")

func _init():
	if not attribute:
		attribute = knockback_attribute
