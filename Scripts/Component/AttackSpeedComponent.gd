class_name AttackSpeedComponent
extends Component

const attack_speed_scene = preload("res://Resources/Data/Attributes/AttackSpeed.tres")


func _init():
	if not attribute:
		attribute = attack_speed_scene
