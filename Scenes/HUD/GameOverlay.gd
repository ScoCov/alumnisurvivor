extends Control
class_name GameOverlay

@export var player: StudentEntity:
	set(value):
		player = value
		$Image/CenterPoint/Sprite2D.texture = player.student.icon
		$Control/Label.text = player.student.student_name
	get:
		return player
@export var timer: Timer
@export var game_logic: GameLogic
const MAX_TIME_LIMIT: int = 300 #in seconds

func _ready():
	pass
	#if not player: return

func _process(_delta):
	update_health()
	update_experience()
	update_win_condition()

func update_experience():
	$Control/Control/VBoxContainer/Experience.value = player.experience.current_xp
	$Control/Control/VBoxContainer/Experience.max_value =  player.experience.next_level_xp
	$Control/Control/VBoxContainer/Experience/Label.text = "(Lvl. %s) %s / %s" % [str(player.experience.level), 
																				str(player.experience.current_xp),
																				str(player.experience.next_level_xp)]

func update_health() -> void:
	if not player: return
	$Control/Control/VBoxContainer/Health/Label.text = "%s / %s" % [player.get_node("Composition/Health").current_health , player.get_node("Composition/Health").max_health  ]
	$Control/Control/VBoxContainer/Health.value = player.get_node("Composition/Health").current_health
	$Control/Control/VBoxContainer/Health.max_value = player.get_node("Composition/Health").max_health
	
	
func update_win_condition()->void:
	if timer:
		$WinConditions/ProgressBar.max_value = timer.wait_time
		$WinConditions/ProgressBar.value = timer.time_left
