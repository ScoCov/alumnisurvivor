class_name BounceComponent
extends Component

const bounce_resource = preload("res://Resources/Data/Attributes/Bounce.tres")


func _init() -> void:
	if not attribute:
		attribute = bounce_resource
