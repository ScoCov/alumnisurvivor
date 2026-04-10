extends Control

@export var student_roster_container: GridContainer
@export var primary_selected: Roster_Selected
@export var secondary_selected: Roster_Selected
@export var animator: AnimationPlayer
@export var ready_button: Button 

var pick_primary: bool = true

func _ready():
	for student_icon: Control in student_roster_container.get_children():
		student_icon.icon_pressed.connect(select_student.bind(student_icon))
	primary_selected.pick_button_pressed.connect(selection_initiated.bind(primary_selected, true, secondary_selected))
	secondary_selected.pick_button_pressed.connect(selection_initiated.bind(secondary_selected, false, primary_selected))
	ready_button.grab_focus()

func selection_initiated(roster_selected: Roster_Selected, is_primary: bool, opposite_selector: Roster_Selected):
	pick_primary = is_primary
	roster_selected.disable_button = true
	opposite_selector.disable_button = true
	animator.play("slide_in")
	
func select_student(student_icon: Roster_Icon):
	pick_student(student_icon.student)
	primary_selected.disable_button = false
	secondary_selected.disable_button = false
	if pick_primary:
		primary_selected.select_button.grab_focus()
	else:
		secondary_selected.select_button.grab_focus()
	
func pick_student(student: Student_Resource):
	if pick_primary:
		Global.select_student_as_primary(student)
	else: 
		Global.select_student_as_secondary(student)
	primary_selected.card_update()
	secondary_selected.card_update()
	primary_selected.disable_button = false
	secondary_selected.disable_button = false
	animator.play("slide_out")
	
func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Maps/Map_Entrance.tscn")

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
