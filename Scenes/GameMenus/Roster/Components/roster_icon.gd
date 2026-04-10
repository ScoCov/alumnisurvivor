class_name Roster_Icon
extends Control

signal student_selected
signal icon_pressed 
signal icon_button_down
signal icon_button_up

@export var student: Student_Resource = Global.SELECTED_STUDENT
@onready var focused = $Focused

func _ready():
	$CenterContainer/Control/Hair.texture = student.hair
	$CenterContainer/Control/Eyes.texture = student.eyes
	$CenterContainer/Control/Eyebrows.texture = student.eyebrows
	$CenterContainer/Control/Mouth.texture = student.mouth
	$ColorRect.color = student.background_color
	if !student.unlocked:
		self.visible = false
		self.focus_mode = Control.FOCUS_NONE
		self.mouse_default_cursor_shape =Control.CURSOR_ARROW
	#if student == Global.SELECTED_STUDENT or Global.SELECTED_BESTY:
		#focused.visible = true

func _on_button_pressed():
	icon_pressed.emit()

func _on_button_button_up():
	icon_button_up.emit()

func _on_button_button_down():
	icon_button_down.emit()
