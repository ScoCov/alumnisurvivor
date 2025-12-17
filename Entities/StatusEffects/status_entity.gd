class_name Status_Effect_Entity
extends Node2D

##This will always be added programmically
var entity: 
	set(value):
		assert(value is Student_Entity or Enemy_Entity, "Entity Must be a Student_Entity or 
			Enemy_Entity")
		entity = value

var repeat: bool = true:
	set(value):
		$Duration.one_shot = value
		repeat = value

func _ready():
	pass

func refresh():
	$Duration.stop()
	$Duration.start()

func _on_duration_timeout():
	pass # Replace with function body.

func _on_tick_timeout():
	pass # Replace with function body.
