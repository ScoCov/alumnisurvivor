extends Control
class_name GameOverlay

signal update

## Place the GameLogic's current active StudentEntity character. The player variable
## will be use to update the health, experience, and many other aspects of the game ui. 
@export var player: StudentEntity:
	set(value):
		player = value
	get:
		return player
		
## Assign the GameLogic's "Game Time" Timer to show how much time is left or has passed.
@export var timer: Timer

func _ready() -> void:
	update_student_ui()

##TODO: Need to replace the process updating constantly.
## I can probably create a signal to update the ui.
func _process(_delta):
	update_timer()

## Update the visual and text-based aspects related to the Student and Besty 
## that is currently assigned in the Global Script. [Global.SELECTED_STUDENT, 
## Global.SELECTED_BESTY]
func update_student_ui() -> void:
	##Student
	$"Control/Student Name".text = "Student: %s" % Global.SELECTED_STUDENT.student_name
	$Image/Control/Student/Hair01.texture = Global.SELECTED_STUDENT.hair
	$Image/Control/Student/Eyebrows01.texture = Global.SELECTED_STUDENT.eyebrows
	$Image/Control/Student/Eyes01.texture = Global.SELECTED_STUDENT.eyes
	$Image/Control/Student/Mouth01.texture = Global.SELECTED_STUDENT.mouth
	##Besty
	$"Control/Besty Name".text = "Besty: %s" % Global.SELECTED_BESTY.student_name
	$Image/Control/Besty/Hair01.texture = Global.SELECTED_BESTY.hair
	$Image/Control/Besty/Eyebrows01.texture = Global.SELECTED_BESTY.eyebrows
	$Image/Control/Besty/Eyes01.texture = Global.SELECTED_BESTY.eyes
	$Image/Control/Besty/Mouth01.texture = Global.SELECTED_BESTY.mouth



##TODO: Need to update once StudentEntity is fully updated.
func update_experience():
	var experience_bar_text = $"Control/Control/VBoxContainer/Experience/Experience Bar Text"
	experience_bar_text.text = "Error!" 
	
	if not player: return
	experience_bar_text.text = ("Level: %s\t\t\t%s needed to level up!" % 
		[player.experience.level, 
		str(player.experience.next_level_xp - player.experience.current_xp)])
		
##TODO: Need to update once StudentEntity is fully updated.
func update_health() -> void:
	var health_bar_text = $"Control/Control/VBoxContainer/Health/Health Bar Text"
	health_bar_text.text = "Error!"
	
	if not player: return
	health_bar_text.text =("%s / %s" % 
	[player.health.current_health, player.health.max_health])

## Updates the game time.
func update_timer()->void:
	if timer:
		$WinConditions/ProgressBar.max_value = timer.wait_time
		$WinConditions/ProgressBar.value = timer.time_left
