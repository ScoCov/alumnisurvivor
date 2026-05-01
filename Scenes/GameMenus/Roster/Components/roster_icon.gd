class_name Roster_Icon
extends Control

signal loaded
signal request_focus

@export var student: Student_Resource = Global.SELECTED_STUDENT:
	set(_student):
		student = _student
	get():
		return student if not null else Global.SELECTED_STUDENT
@export var student_head: Body_Part_Student_Head

@export_category("Nodes")
@onready var focused: Panel = $Focused
@onready var background_color_node: ColorRect = $ColorRect


func _ready():
	loaded.emit()

func _on_loaded():
	student_head.build_head(student)
	var tStyle = student
	var ntStyle:= StyleBoxTexture.new()
	var background: GradientTexture2D = load("res://Assets/Image/Textures/roster_icon_focus.tres")
	var nTxtr = background.duplicate(true)
	nTxtr.gradient.colors = [student.background_color, Color(0,0,0,0) ]
	ntStyle.texture = nTxtr
	focused.add_theme_stylebox_override("panel", ntStyle)



func _on_button_pressed():
	request_focus.emit()
