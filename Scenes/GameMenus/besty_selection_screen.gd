extends Control


const student_icon_scene: PackedScene = preload("res://Scenes/GameMenus/student_icon.tscn")
@onready var student_grid = $MarginContainer/VSplitContainer/VBoxContainer/Students/MarginContainer/StudentGrid


func _ready():
	Global.SELECTED_BESTY = Global.STUDENT_ROSTER.filter(
		func(student): return student != Global.SELECTED_STUDENT)[0]
	populate_student_roster()
	populate_besty_data()
	var list_of_besties = $MarginContainer/VSplitContainer/VBoxContainer/Students/MarginContainer/StudentGrid.get_children()
	var filtered_list = list_of_besties.filter(func(e): return e.student != Global.SELECTED_STUDENT and e.student.unlocked)
	filtered_list.sort_custom(func(a,b): return a.student.ordinal < b.student.ordinal )
	filtered_list[0].grab_focus()

func populate_student_roster() -> void:
	##Load students, populate container.
	## Auto-Populates students based on their Student Resource Existing.
	## Checks for Student's unlocked/locked status.
	for student: StudentResource in Global.STUDENT_ROSTER:
		var new_student_icon: Student_Icon = student_icon_scene.instantiate()
		new_student_icon.student = student
		if not student.unlocked:
			new_student_icon.focus_mode = Control.FOCUS_NONE
			new_student_icon.disabled = true
		new_student_icon.select_student = false
		new_student_icon.currently_selected_student = true if student == Global.SELECTED_STUDENT else false
		new_student_icon.focus_entered.connect(populate_besty_data)
		student_grid.add_child(new_student_icon)
		



func populate_besty_data():
	$"Stats Box/MarginContainer/Control/Title/Control/VBoxContainer/Student Name/Label".text = Global.SELECTED_BESTY.student_name
	#$"Stats Box/MarginContainer/Control/Title/Control/VBoxContainer/Primary/Label".text = Global.SELECTED_BESTY.primary.attribute_name
	#$"Stats Box/MarginContainer/Control/Title/Control/VBoxContainer/Secondary/Label".text = Global.SELETED_BESTY.secondary.attribute_name
	#$"Stats Box/MarginContainer/Control/Title/Control/VBoxContainer/Weakness/Label".test = Global.SELECTED_BESTY.weakness.attribute_name


func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/GameMenus/student_selection_screen.tscn")


func _on_select_map_pressed():
	get_tree().change_scene_to_file("res://Scenes/GameMenus/map_selection_screen.tscn")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Background_Movement":
		$Background/AnimationPlayer.play("Background_Movement")
