@tool
class_name Dash_Indicator
extends Control

signal value_change
signal dash_restored
signal dash_consumed

@export var ready_to_dash: bool = true:
	set(_ready):
		$Ready.visible = _ready
		ready_to_dash = _ready
		value_change.emit()
		if not _ready and cooldown.is_stopped():
			cooldown.start()
		if _ready:
			dash_restored.emit()
		else:
			dash_consumed.emit()
	get:
		return ready_to_dash
		
@onready var cooldown = $Cooldown

func _on_cooldown_timeout():
	ready_to_dash = true
