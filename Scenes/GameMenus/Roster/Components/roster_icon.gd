class_name Roster_Icon
extends Control

signal icon_pressed 
signal icon_button_down
signal icon_button_up

@export var student: Student_Resource = Global.SELECTED_STUDENT

@export_category("Nodes")
@export var focused: Panel 
@export var head: Sprite2D
@export var hair: Sprite2D
@export var eyebrows: Sprite2D
@export var eyes: Sprite2D
@export var mouth: Sprite2D
@export var background_color: ColorRect

func _ready():
	hair.texture = student.hair
	eyes.texture = student.eyes
	eyebrows.texture = student.eyebrows
	mouth.texture = student.mouth
	background_color.color = student.background_color
	if !student.unlocked:
		self.visible = false
		self.focus_mode = Control.FOCUS_NONE
		self.mouse_default_cursor_shape =Control.CURSOR_ARROW

func _on_button_pressed():
	icon_pressed.emit()

func _on_button_button_up():
	icon_button_up.emit()

func _on_button_button_down():
	icon_button_down.emit()
