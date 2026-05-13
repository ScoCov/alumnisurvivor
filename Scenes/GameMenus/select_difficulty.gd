class_name Menu_Select_Difficulty
extends Control

@export var diff_title: Label

func _ready():
	##TODO: Get difficulty from Save File
	##FOR NOW, default to Normal
	change_diff_name("Normal")
	##TODO: Disable Difficulty Buttons after Normal from Save File

func change_diff_name(title: String = ""):
	diff_title.text = "Difficulty: %s" % title

func _on_normal_pressed():
	change_diff_name("Normal")
	Global.CURRENT_RUN.current_difficulty = Difficulty.MODE.NORMAL
	
func _on_difficult_pressed():
	change_diff_name("Difficult")
	Global.CURRENT_RUN.current_difficulty = Difficulty.MODE.DIFFICULT
	
func _on_hard_pressed():
	change_diff_name("Hard")
	Global.CURRENT_RUN.current_difficulty = Difficulty.MODE.HARD
	
func _on_very_hard_pressed():
	change_diff_name("Very Hard")
	Global.CURRENT_RUN.current_difficulty = Difficulty.MODE.VERY_HARD
	
func _on_impossible_pressed():
	change_diff_name("Impossible")
	Global.CURRENT_RUN.current_difficulty = Difficulty.MODE.IMPOSSIBLE
	
func _on_legendary_pressed():
	change_diff_name("Legendary")
	Global.CURRENT_RUN.current_difficulty = Difficulty.MODE.LEGENDARY

func _on_confirm_pressed():
	get_tree().change_scene_to_file("res://Scenes/Maps/school_map.tscn")

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/GameMenus/Roster/student_roster.tscn")
