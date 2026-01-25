@tool
class_name Dash_Indicator
extends Control

signal value_change

@export var ready_to_dash: bool = true:
	set(_ready):
		$Ready.visible = _ready
		ready_to_dash = _ready
		if not _ready and cooldown != null:
			cooldown.start()
		value_change.emit()
	get:
		return ready_to_dash
		
@onready var cooldown = $Cooldown

func _on_cooldown_timeout():
	ready_to_dash = true
