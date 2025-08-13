extends Control
class_name GameOverlay

@export var player: StudentPlayer
@export var timer: Timer
const MAX_TIME_LIMIT: int = 30 #in seconds

func _ready():
	pass
	#player.stats.attributes["ATTRIBUTE_HEALTH"].low_health.connect(func(): print("LOW HEALTH"))
	#update_health()

func _process(_delta):
	update_health()
	update_win_condition()

func update_health():
	if not player:
		return
	if (player.stats.attributes["ATTRIBUTE_HEALTH"] as HealthComponent):
		var p_stats:= player.stats.attributes["ATTRIBUTE_HEALTH"] as HealthComponent
		$Control/Control/VBoxContainer/Health.max_value = p_stats.base_value 
		$'Control/Control/VBoxContainer/Health'.value = p_stats.current_health
		$Control/Control/VBoxContainer/Health/Label.text = str(p_stats.current_health) + " / " + str(player.stats.attributes["ATTRIBUTE_HEALTH"].value)
		$Image/CenterPoint/Sprite2D.texture = player.student.icon
		$Control/Label.text = player.student.student_name + " & " + player.besty.student_name
		
func update_win_condition()->void:
	if timer:
		$WinConditions/ProgressBar.max_value = timer.wait_time
		$WinConditions/ProgressBar.value = timer.time_left
	
