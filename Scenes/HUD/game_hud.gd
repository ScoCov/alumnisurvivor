class_name Game_HUD
extends Control

enum STUDENT_OPTIONS {STUDENT, BESTY} 
enum UPDATE_OPTIONS {STUDENT_AND_BESTY, HEALTH, EXPERIENCE, TIME}

@export var game_ui: Game_Ui

@onready var student_name = $"Student Info/Student Name"
@onready var besty_name = $"Student Info/Besty Name"
@onready var health = $"Student Info/Control/VBoxContainer/Health"
@onready var health_bar_text = $"Student Info/Control/VBoxContainer/Health/Health Bar Text"
@onready var experience_bar = $ExperienceBar
@onready var experience_bar_text = $"ExperienceBar/Experience Bar Text"
@onready var debug_info = $"Debug Info"
@onready var ability_info = $"Ability Info"
@onready var cooldown_visual = $"Ability Info/Cooldown Visual"
@onready var ability_info_label = $"Ability Info/Name"
@onready var ability_timeleft = $"Ability Info/Timeleft"
@onready var student: Body_Part_Student_Head = $Image/Control/Student
@onready var besty: Body_Part_Student_Head = $Image/Control/Besty

func _ready():
	pass
	
func _process(_delta):
	#if Global.DEBUG_MODE:
		#update_debug_info()
	pass
	
func update_hud_static():
	## Develop Names
	
	update_experience_values()
		
func update_faces():
	var alt_student = Global.CURRENT_RUN.current_player_entity.student_manager.besty_student
	if alt_student == Global.CURRENT_RUN.current_player_entity.student_manager.active_student:
		alt_student = Global.CURRENT_RUN.current_player_entity.student_manager.primary_student
	## Figure out how to change the names to the appropriate student names.
	## student_name.text = "Active Student"
	## besty_name.text = "Non-Active Student" 
	student.build_head(Global.CURRENT_RUN.current_player_entity.student_manager.active_student)
	besty.build_head(alt_student)
	
func update_health_values():
	var _student = game_ui.player
	health.max_value = _student.health.maximum_health
	health.value = _student.health.current_health
	health_bar_text.text = "%s/%s" % [_student.health.current_health, _student.health.maximum_health]
	
func update_experience_values():
	var _student = game_ui.player
	experience_bar.max_value = _student.experience.xp_until_level_up
	experience_bar.value = _student.experience.current_xp
	experience_bar_text.text = "Lvl. %s     EXP: %s        (Next Level: %s)" % [_student.experience.player_level, _student.experience.current_xp, _student.experience.xp_until_level_up]

func update_debug_info():
	var enemy_spawner: Enemy_Spawner = game_ui.game_logic.enemy_spawner
	$"Debug Info/MarginContainer/VBoxContainer/Enemy Power".text = "Power [Current/Max]: %s / %s" % [enemy_spawner.current_pwer, enemy_spawner.max_power]
	$"Debug Info/MarginContainer/VBoxContainer/Spawn Chance".text = "Spawn Chance: %s" % [enemy_spawner.spawn_chance]
	$"Debug Info/MarginContainer/VBoxContainer/Number of Enemies".text = "Enemy Count: %s" % [enemy_spawner.enemy_container.get_child_count()]
