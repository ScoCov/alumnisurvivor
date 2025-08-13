class_name RangeComponent
extends Component

const range_attribute:= preload("res://Resources/Data/Attributes/Range.tres")

func _init():
	if not attribute: 
		attribute = range_attribute
