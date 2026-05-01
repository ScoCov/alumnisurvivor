class_name Body_Part_Student_Head
extends Node2D

@export var bob_head: bool = true

@export var debug: bool = true
@export var test_student: Student_Resource
@export var hair_has_back: bool = false

@onready var head = $Container/Head
@onready var mouth = $Container/Mouth
@onready var eyes = $Container/Eyes
@onready var eyebrows = $Container/Eyebrows
@onready var hair = $Container/Hair
@onready var hair_back = $Container/HairBack

func _ready():
	if debug and test_student:
		build_head(test_student)
	if bob_head:
		$AnimationPlayer.play("head_bob")
	
func build_head(student: Student_Resource):
	head.texture = get_part_by_string("Head", student)
	eyes.texture = get_part_by_string("Eyes", student)
	var temp = student.hair_variant
	if student.hair_variant in [1,2]:
		hair.texture = get_hair(student, {"front": true})
		hair_back.texture = get_hair(student, {"back": true})
	else:
		hair.texture = get_hair(student)
		hair_back.texture = null

## Can get all parts except hair, which can break. If hair only has one piece of it, this is fine.
func get_part_by_string(part: String, student: Student_Resource):
	var variant = student["%s_variant" % part.to_lower()]  + 1
	var color = student["%s_color" % part.to_lower()] + 1
	var string_1 = "res://Assets/Image/Student/Head/"
	var string_2 = "%s Variants/%s 0%s/%s_0%s_0%s.png" % [part, part, variant,part,variant,color]
	var load_string = string_1 + string_2
	var new_texture = load(load_string)
	return new_texture
	
func get_hair(student: Student_Resource, arg_obj: Dictionary = {}):
	var variant = student["hair_variant" ]  + 1
	var color = student["hair_color"] + 1
	var string_1 = "res://Assets/Image/Student/Head/"
	var args = ""
	if arg_obj.has("front"):
		args = "_F"
	if arg_obj.has("back"):
		args = "_B"
	var string_2 = "Hair Variants/Hair 0%s/Hair_0%s_0%s%s.png" % [variant,variant,color, args]
	var load_string = string_1 + string_2
	var new_texture = load(load_string)
	return new_texture
	
