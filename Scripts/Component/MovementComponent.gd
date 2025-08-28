class_name MovementComponent
extends Component

const movement_attribute: AttributeResource = preload("res://Resources/Data/Attributes/MovementSpeed.tres")

func _init():
	if not attribute:
		attribute = movement_attribute
