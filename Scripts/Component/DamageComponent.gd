class_name DamageComponent
extends Component

const damage_attribute = preload("res://Resources/Data/Attributes/Damage.tres")

func _init():
	if not attribute:
		attribute = damage_attribute
