extends Control
class_name StudentPage


@export var student: Student
@onready var information_page = $Body/MarginContainer/Content/TabContainer/Information/MarginContainer/VBoxContainer
@onready var header = $Body/MarginContainer/Content


func _ready(): 
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
	if student == Global.SELECTED_STUDENT:
		header.get_node("Info/Control/VBoxContainer/SelectedAs").text = "Player"
	if student == Global.SELECTED_BESTY:
		header.get_node("Info/Control/VBoxContainer/SelectedAs").text = "Besty"


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
	

func swipe_in():
	$AnimationPlayer.play("swipe_in")

func swipe_out():
	$AnimationPlayer.play("slide_out")
