class_name PickupRangeComponent
extends Component

const pickup_range_scene = preload("res://Resources/Data/Attributes/AttackSpeed.tres")


func _init():
	if not attribute:
		attribute = pickup_range_scene
