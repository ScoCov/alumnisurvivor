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


func _ready():
	debug_info.visible = game_ui.debug_mode
	
func _process(_delta):
	if game_ui.debug_mode:
		update_debug_info()
	update_health_values()
	update_ability_info()
	update_experience_values()

func update_items():
	var items = $"Debug Info/MarginContainer/VBoxContainer/Items"
	items.text = "Items: %s" % game_ui.player.items.map(func(e): return e.item_name)
	
func update_hud_static():
	## Develop Names
	student_name.text = Global.SELECTED_STUDENT.student_name
	besty_name.text = Global.SELECTED_BESTY.student_name
	## Fill out Faces
	update_faces(Global.SELECTED_STUDENT, STUDENT_OPTIONS.STUDENT)
	update_faces(Global.SELECTED_BESTY, STUDENT_OPTIONS.BESTY)
	## Update Health
	#update_health_values()
	## Update Experience
	update_experience_values()
		
func update_faces(_student:Student_Resource, option: STUDENT_OPTIONS ):
	var control: Control = $Image/Control
	var target = control.find_child("Student" if option == STUDENT_OPTIONS.STUDENT else "Besty")
	var resource = Global.SELECTED_STUDENT if option == STUDENT_OPTIONS.STUDENT else Global.SELECTED_BESTY
	for part in target.get_children():
		part.texture = resource[part.name.to_lower()]
	
func update_health_values():
	var student = game_ui.player
	health.max_value = student.health.maximum_health
	health.value = student.health.current_health
	health_bar_text.text = "%s/%s" % [student.health.current_health, student.health.maximum_health]
	
func update_experience_values():
	var student = game_ui.player
	experience_bar.max_value = student.experience.xp_until_level_up
	experience_bar.value = student.experience.current_xp
	experience_bar_text.text = "Lvl. %s     EXP: %s        (Next Level: %s)" % [student.experience.player_level, student.experience.current_xp, student.experience.xp_until_level_up]

func update_ability_info():
	#var x_height = ability_info.get_transform().y
	var ability_entity: Ability_Entity = game_ui.player.abilities.get_child(0)
	var rect: Rect2 = ability_info.get_rect()
	if ability_entity.cooldown.time_left > 0:
		var percentage_complete =  ability_entity.cooldown.time_left / ability_entity.cooldown.wait_time
		var y_size = rect.size.y * percentage_complete
		cooldown_visual.size.y = rect.size.y - y_size
		ability_timeleft.text = str(Utility.round_to_dec( ability_entity.cooldown.time_left, 2))
	else:
		rect.size.y = 0
		ability_timeleft.text = ""
	ability_info_label.text = ability_entity.ability.ability_name
	
	pass

func update_debug_info():
	var enemy_spawner: Enemy_Spawner = game_ui.game_logic.enemy_spawner
	$"Debug Info/MarginContainer/VBoxContainer/Enemy Power".text = "Power [Current/Max]: %s / %s" % [enemy_spawner.current_pwer, enemy_spawner.max_power]
	$"Debug Info/MarginContainer/VBoxContainer/Spawn Chance".text = "Spawn Chance: %s" % [enemy_spawner.spawn_chance]
	$"Debug Info/MarginContainer/VBoxContainer/Number of Enemies".text = "Enemy Count: %s" % [enemy_spawner.enemy_container.get_child_count()]
