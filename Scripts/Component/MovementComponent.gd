class_name MovementComponent
extends Component

const movement_attribute: Attribute = preload("res://Resources/Data/Attributes/MovementSpeed.tres")


func _init():
	if !attribute:
		attribute = movement_attribute
