class_name Student_Manager
extends Node

signal student_swap

@export var starter_student: _student_options:
	set(value):
		_current_student = value
		
enum _student_options {STUDENT, BESTY}

var _current_student: _student_options:
	set(value):
		swap_students(value)
		_current_student = value

## This class variable is to be used as the currently active student between primary and besty student.
var active_student: StudentResource

## Primary Student is always the "SELECTED_STUDENT" from Global
var primary_student: StudentResource:
	get():
		return Global.SELECTED_STUDENT
## Besty Student is always the "SELECTED_BESTY" from Global
var besty_student: StudentResource:
	get():
		return Global.SELECTED_BESTY

func _input(event):
	if event.is_action_pressed("swap_besty"):
		if _current_student == _student_options.STUDENT:
			_current_student = _student_options.BESTY
		else:
			_current_student = _student_options.STUDENT

func swap_students(student: _student_options):
	if student == _student_options.STUDENT:
		active_student = primary_student
	if student == _student_options.BESTY:
		active_student = besty_student
	student_swap.emit()
