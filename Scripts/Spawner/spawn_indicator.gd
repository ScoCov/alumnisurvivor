class_name Spawn_Inidcator
extends Node2D



@export var duration: float = 1.0


func _ready():
	$Duration.wait_time = duration

func _on_duration_timeout():
	## SPAWN SINGULAR ENEMY
	self.queue_free()
