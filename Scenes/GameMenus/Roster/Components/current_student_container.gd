class_name Roster_Selected
extends Control

enum student_type {MAIN, BESTY} 

@export var student_or_besty: student_type = student_type.MAIN
@export var student_head: Body_Part_Student_Head

@onready var background_panel = $Panel
@onready var student_name = $Panel/MarginContainer/Panel/Label
@onready var animation_player = $AnimationPlayer
@onready var bg_box = $Panel/Display/bg_box
@onready var box = $Panel/Display/Box
@onready var border = $Border

var student: Student_Resource:
	get():
		if student_or_besty == student_type.MAIN:
			return Global.SELECTED_STUDENT
		return Global.SELECTED_BESTY
			
func _ready():
	card_update()

func card_update(animate: bool = false):
	if animate: animation_player.play("changed_student")
	populate_image()
	update_student_name()
	update_ability_text()
	update_passive_description()

func update_ability_text():
	var ability_name = $Panel/Ability_Data/Panel/MarginContainer/AbilityName
	ability_name.text = "Ability: %s" % student.starting_ability.display_name

func update_student_name():
	student_name.text = "%s %s" % ["Support:" if bool(student_or_besty) else "Player:" ,student.student_name]

func update_passive_description():
	var rt_label = $Panel/Data/Panel/MarginContainer/RichTextLabel
	rt_label.text = "As a Besty:\n\nIf Player is struck by an enemy the player will get a small movement speed boost for 3s."

func populate_image():
	student_head.build_head(student)
	border_color()
	
func border_color():
	var curr_stylebox: StyleBoxFlat = background_panel.get_theme_stylebox("panel")
	var new_stylebox:= StyleBoxFlat.new()
	var tR: TextureRect = $Panel/Display/bg_box/TextureRect
	tR.texture.setup_local_to_scene()
	var textRest = load("res://Assets/Image/Textures/radial_gradient.tres")
	#textRest.setup_local_to_scene()
	var tXR = textRest.duplicate(true)
	tXR.gradient.colors = [student.background_color, Color(0,0,0,0)]
	tR.texture = tXR
	new_stylebox.bg_color = student.background_color/2
	new_stylebox.set_corner_radius_all(curr_stylebox.corner_radius_bottom_left)
	new_stylebox.set_border_width_all(curr_stylebox.border_width_left)
	new_stylebox.shadow_size = curr_stylebox.shadow_size
	new_stylebox.shadow_offset = curr_stylebox.shadow_offset
	new_stylebox.draw_center = true
	background_panel.add_theme_stylebox_override("panel",new_stylebox)
	var sprite_2d = $Panel/Sprite2D
	sprite_2d.modulate = student.background_color/3
