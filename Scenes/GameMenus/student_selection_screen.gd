extends Control

const student_icon_scene: PackedScene = preload("res://Scenes/GameMenus/student_icon.tscn")
@onready var student_entity = $"Doll Container/Center/StudentEntity"
@onready var student_grid = $MarginContainer/VSplitContainer/VBoxContainer/Students/MarginContainer/StudentGrid

func _ready() -> void:
	student_entity.find_child("AnimationPlayer").play("walk")
	populate_student_roster()
	
func populate_student_roster() -> void:
	##Load students, populate container.
	## Auto-Populates students based on their Student Resource Existing.
	## Checks for Student's unlocked/locked status.
	for student: StudentResource in Global.STUDENT_ROSTER:
		var new_student_icon: Student_Icon = student_icon_scene.instantiate()
		new_student_icon.student = student
		new_student_icon.focus_entered.connect(update_student_doll.bind(student) )
		if not student.unlocked:
			new_student_icon.focus_mode = Control.FOCUS_NONE
			new_student_icon.disabled = true
		student_grid.add_child(new_student_icon)
		if student.file_name == Global.SELECTED_STUDENT.file_name:
			new_student_icon.grab_focus()

func update_student_doll(student: StudentResource):
	var attribute_container = $"Stats Menu/MarginContainer/VSplitContainer/ScrollContainer/Attributes"
	student_entity.student_update(student)
	$"Doll Container/RichTextLabel".text = "%s" % student.student_name
	for row in attribute_container.get_children():
		row.queue_free()
				
func select_student_as_player(student, student_icon):
	print("Select_student_as_player has triggered")
	Global.SELECTED_STUDENT = student
	student_icon.find_child("Focus Border").visible = true

func create_stat_row(student: StudentResource , _attribute_resource: AttributeResource) -> RichTextLabel:
	var main_label:= RichTextLabel.new()
	var number_label:= RichTextLabel.new()
	main_label.fit_content = true
	main_label.text = "%s:" % _attribute_resource.name
	number_label.fit_content = true
	number_label.text = "%s\t\t" % str(student[_attribute_resource.id])
	number_label.set_anchors_preset(Control.PRESET_FULL_RECT, false)
	number_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	main_label.add_child(number_label)
	return main_label

func _on_bgm_01_finished():
	$Bgm01.play(0)

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")

func _on_to_besty_select_pressed():
	get_tree().change_scene_to_file("res://Scenes/GameMenus/besty_selection_screen.tscn")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Background_Movement":
		$Background/AnimationPlayer.play("Background_Movement")
