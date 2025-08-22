extends CharacterBody2D
class_name EnemyEntity

signal death

var player: StudentEntity
var spawner_ref: EnemySpawner
@export var resource: EnemyResource


func _physics_process(_delta):
	if $Composition/Health.current_health < 1:
		death.emit()
		queue_free()
