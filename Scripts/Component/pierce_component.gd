class_name PierceComponent
extends Component

const pierce_resource = preload("res://Resources/Data/Attributes/Pierce.tres")

func _init() -> void:
	if not attribute:
		attribute = pierce_resource
