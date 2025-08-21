class_name EnemyAngryStudent
extends EnemyEntity

var angry_student_resource: EnemyResource = preload("res://Resources/Data/Enemies/angry_student.tres")

func _init():
	enemy = angry_student_resource

func _ready():
	print("Enemy is present prior to _ready. (%s)" % str(enemy != null))
	#enemy = angry_student_resource
	$Sprite.texture = enemy.image	

