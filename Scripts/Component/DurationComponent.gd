class_name DurationComponent
extends Component

const duration_attribute = preload("res://Resources/Data/Attributes/Duration.tres")

func _init():
	if not attribute:
		attribute = duration_attribute
