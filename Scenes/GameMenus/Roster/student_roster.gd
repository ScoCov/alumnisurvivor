class_name Page_Student_Roster
extends Control

@export var primary_selected: Roster_Selected
@export var secondary_selected: Roster_Selected
@export var animator: AnimationPlayer
@export var student_selector: Roster_Student_Selector
@export var bonus_box: VBoxContainer

func _ready():
	build_status_bonuses()

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")

func _on_selector_control_ready_pressed():
	get_tree().change_scene_to_file("res://Scenes/Maps/Map_Entrance.tscn")

func _on_selector_control_student_selected():
	select(student_selector.focused_student.student, true)

func _on_selector_control_besty_selected():
	select(student_selector.focused_student.student, false)

func select(student: Student_Resource, is_primary: bool = true):
	var swapped: bool = false

	if is_primary:
		swapped = Global.select_student_as_primary(student)
	else: 
		swapped = Global.select_student_as_secondary(student)
		
	primary_selected.card_update(swapped or is_primary)
	secondary_selected.card_update(swapped or not is_primary)
	build_status_bonuses()
	
func build_status_bonuses():
	if bonus_box.get_child_count() > 0:
		while (bonus_box.get_child_count() > 0):
			bonus_box.remove_child(bonus_box.get_child(0))
	## Get Student's bonuses:
	var student_title := Label.new()
	student_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	student_title.text = "Bonuses from Player"
	bonus_box.add_child(student_title)
	bonus_box.add_child(bonus_row(Global.SELECTED_STUDENT.primary.name, "+20%"))
	bonus_box.add_child(bonus_row(Global.SELECTED_STUDENT.secondary.name, "+10%"))
	bonus_box.add_child(bonus_row(Global.SELECTED_STUDENT.weakness.name, "-10%"))
	## Get Besty's bonuses:
	var besty_title:= Label.new()
	besty_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	bonus_box.add_child(besty_title)
	besty_title.text = "Bonuses from Besty"
	bonus_box.add_child(bonus_row(Global.SELECTED_BESTY.primary.name, "+10%"))
	bonus_box.add_child(bonus_row(Global.SELECTED_BESTY.secondary.name, "+5%"))
	bonus_box.add_child(bonus_row(Global.SELECTED_BESTY.weakness.name, "-10%"))
	
func bonus_row(main_text: String, number_text: String) -> Label:
	var new_label:= Label.new()
	new_label.text = "%s" % main_text
	new_label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var child_label:= Label.new()
	new_label.add_child(child_label)
	child_label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	child_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	child_label.text = "%s" % number_text
	return new_label
	
