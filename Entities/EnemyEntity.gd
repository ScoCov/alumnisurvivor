extends CharacterBody2D
class_name EnemyEntity

signal take_damage
signal spawn 
signal death

@export var player: StudentPlayer
@warning_ignore("unused_private_class_variable")
@export var _spawner_ref: EnemySpawner

var enemy: EnemyResource


func _init():
	pass

func _ready():
	pass
