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
var hud_item_scene = preload("res://Scenes/HUD/hud_item.tscn")

func _ready():
	pass
	#if not player: return

func _process(_delta):
	update_health()
	update_experience()
	update_win_condition()
	update_items()

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

func update_items() -> void:
	if player.items.get_child_count() == $Items/GridContainer.get_child_count(): return
	for item_stack: ItemStack in player.items.get_children():
		if not $Items/GridContainer.get_children().any(func(node): return node.item_stack == item_stack):
			var new_hud_item:= hud_item_scene.instantiate()
			new_hud_item.item_stack = item_stack
			new_hud_item.update()
			$Items/GridContainer.add_child(new_hud_item)
		else:
			$Items/GridContainer.get_children().filter(func(node): return node.item_stack == item_stack)[0].update()
