extends Control
class_name StudentPage


@export var student: Student
@onready var information_page = $Body/MarginContainer/Content/TabContainer/Information/MarginContainer/VBoxContainer
@onready var header = $Body/MarginContainer/Content


func _ready(): 
	if not student:
		return null
	var hdr = func(path: String, property: String = "text"):
		match property:
			"text":
				return header.get_node("Info/Control/VBoxContainer/"+path)
			"texture":
				return header.get_node("Info/Image/"+path)
	hdr.call("Sprite2D", "texture").texture = student.icon
	hdr.call("Name").text = student.student_name
	hdr.call("Nickname").text = student.title_or_nickname
	
	var info_page = func info_page(target,value) -> void: 
		information_page.get_node(target+"/Label").text = value
	info_page.call("Primary", student.primary_skill)
	info_page.call("Secondary", student.secondary_skill)
	info_page.call("Weakness", student.weakness_skill)
	info_page.call("Ability", student.starting_ability)
	
	if student == Global.SELECTED_STUDENT:
		hdr.call("SelectedAs").text = "Player"
	if student == Global.SELECTED_BESTY:
		hdr.call("SelectedAs").text = "Besty"

func update():
	if not student:
		return null
		#student = load("res://Resources/Data/Students/Student1.tres")
	header.get_node("Info/Image/Sprite2D").texture = student.icon
	header.get_node("Info/Control/VBoxContainer/Name").text = student.student_name
	header.get_node("Info/Control/VBoxContainer/Nickname").text = student.title_or_nickname
	
	information_page.get_node("Primary/Label").text = student.primary_skill
	information_page.get_node("Secondary/Label").text = student.secondary_skill
	information_page.get_node("Weakness/Label").text = student.weakness_skill
	information_page.get_node("Ability/Label").text = student.starting_ability
	header.get_node("Info/Control/VBoxContainer/SelectedAs").text =  ""
	if student == Global.SELECTED_STUDENT:
		header.get_node("Info/Control/VBoxContainer/SelectedAs").text = "Player"
		
	if student == Global.SELECTED_BESTY:
		header.get_node("Info/Control/VBoxContainer/SelectedAs").text = "Besty"

func _on_tab_bar_tab_clicked(tab):
	var tab_con = $Body/MarginContainer/Content/TabContainer
	tab_con.current_tab = tab

#TEST: Testing why the body keeps resizing for some reason.
func _on_body_resized():
	const _VALID_SIZE:= Vector2(375, 555)
	size = Vector2(floor($Body.size.x), floor($Body.size.y)) #Normalize the size
	assert(size == _VALID_SIZE , "Your size is incorrect! You have: %s, and need %s." % [str($Body.size), str(_VALID_SIZE) ])
