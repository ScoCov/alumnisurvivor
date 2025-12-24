extends Control
class_name Game_Ui

## Place the GameLogic's current active StudentEntity character. The player variable
## will be use to update the health, experience, and many other aspects of the game ui. 
@export var player: Student_Entity:
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
	update_health()

## Update the visual and text-based aspects related to the Student and Besty 
## that is currently assigned in the Global Script. [Global.SELECTED_STUDENT, 
## Global.SELECTED_BESTY]
func update_student_ui() -> void:
	$"Control/Student Name".text = "Student: %s" % Global.SELECTED_STUDENT.student_name
	$"Control/Besty Name".text = "Besty: %s" % Global.SELECTED_BESTY.student_name
	var versions = find_child("Image").find_child("Control")
	for version in versions.get_children().map(func(ver): return ver.name):
		var parts = versions.find_child(version).get_children().map(func(par): return par.name)
		for part in parts:
			_get_facial_node(version, part).texture = Global["SELECTED_%s" % 
			version.to_upper()][part.to_lower()]


## Give two inputs, version being either a student or besty. 
## Then give which part you wish to update.
func _get_facial_node(version: String, part: String) -> Sprite2D:
	assert(version.to_lower() == "student" or "besty","Version must be \'Student\' or \'Besty\'" )
	assert (part.to_lower() in ["hair", "eyebrows", "eyes", "mouth"], "Part must exist.")
	return find_child(version).find_child(part)

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
	$Control/Control/VBoxContainer/Health.value = player.health.current_health
	$Control/Control/VBoxContainer/Health.max_value = player.health.maximum_health
	if player.health.current_health as float / player.health.maximum_health > 1:
		var new_stylebox:= StyleBoxFlat.new()
		new_stylebox.bg_color = Color.ROYAL_BLUE
		$Control/Control/VBoxContainer/Health.add_theme_stylebox_override("fill",new_stylebox )
	else:
		var new_stylebox:= StyleBoxFlat.new()
		new_stylebox.bg_color = Color.RED
		$Control/Control/VBoxContainer/Health.add_theme_stylebox_override("fill",new_stylebox )
	health_bar_text.text =("%s / %s" % 
	[player.health.current_health, player.health.maximum_health])

## Updates the game time.
func update_timer()->void:
	if timer:
		$WinConditions/ProgressBar.max_value = timer.wait_time
		$WinConditions/ProgressBar.value = timer.time_left
