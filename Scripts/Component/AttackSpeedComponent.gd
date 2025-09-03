class_name PickupRangeComponent
extends Component

const pickup_range = preload("res://Resources/Data/Attributes/PickupRange.tres")


func _init():
	if not attribute:
		attribute = pickup_range
