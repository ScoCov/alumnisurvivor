class_name Roster_Selected
extends Control

signal pick_button_pressed
signal pick_button_down
signal pick_button_up

enum student_type {MAIN, BESTY} 

@export var student_or_besty: student_type = student_type.MAIN
@export var select_button: Button
@export var disable_button: bool = false:
	set(disabled):
		disable_button = disabled
		select_button.disabled = disabled

@onready var background_panel = $Panel
@onready var background_color = $ColorRect

@onready var student_name = $Panel/MarginContainer/Panel/Label
@onready var primary = $Panel/Data/Panel/MarginContainer/VBoxContainer/primary
@onready var secondary = $Panel/Data/Panel/MarginContainer/VBoxContainer/secondary
@onready var weakness = $Panel/Data/Panel/MarginContainer/VBoxContainer/weakness
@onready var ability = $Panel/Data/Panel/MarginContainer/VBoxContainer/ability

@onready var head = $Panel/Display/CenterContainer/Control/Head
@onready var hair = $Panel/Display/CenterContainer/Control/Hair
@onready var eyebrows = $Panel/Display/CenterContainer/Control/Eyebrows
@onready var eyes = $Panel/Display/CenterContainer/Control/Eyes
@onready var mouth = $Panel/Display/CenterContainer/Control/Mouth

var student: Student_Resource:
	get():
		if student_or_besty == student_type.MAIN:
			return Global.SELECTED_STUDENT
		return Global.SELECTED_BESTY
			
func _ready():
	card_update()
	pass

func card_update():
	populate_image()
	populate_text()

func populate_text():
	student_name.text = "%s: \t%s" % [get_student_type(student_or_besty), student.student_name]
	primary.text = "Primary: \t%s" % student.primary.name
	secondary.text = "Secondary: \t%s" % student.secondary.name
	weakness.text = "Weakness: \t%s" % student.weakness.name
	ability.text = "Ability: \t%s" % student.starting_ability.ability_name 
	background_color.color = student.background_color

func get_student_type(index: int)-> String:
	var return_string
	match index:
		0:
			return_string = "Main"
		1: 
			return_string = "Besty"
	return return_string

func populate_image():
	hair.texture = student.hair
	eyebrows.texture = student.eyebrows
	eyes.texture = student.eyes
	mouth.texture = student.mouth

func _on_button_pressed():
	pick_button_pressed.emit()

func _on_button_button_up():
	pick_button_up.emit()

func _on_button_button_down():
	pick_button_down.emit()
