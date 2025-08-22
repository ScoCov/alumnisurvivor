class_name StudentEntity
extends CharacterBody2D

signal take_damage

@export var student: StudentResource
#var besty: StudentResource
## Import a Student Resource to obtain unique data.
var global_projectile_container: Node

func _ready():
	if student:
		$Sprite.texture = student.doll
	
func _process(_delta):
	pass
	 
