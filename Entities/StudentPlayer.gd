extends CharacterBody2D
class_name StudentPlayer

signal take_damage

## Import a Student Resource to obtain unique data.
@export var student: Student
@export var besty: Student
@export var global_projectile_container: Node

@onready var item_list: ItemManager = $Items
@onready var stats: Stats = $Stats

func _ready():
	if not student:
		student = Global.SELECTED_STUDENT
	if not besty:
		besty = Global.SELECTED_BESTY
	$'Sprite2D'.texture = student.doll
	
func _process(_delta):
	$AbilitySlot1.look_at(get_global_mouse_position())
	
