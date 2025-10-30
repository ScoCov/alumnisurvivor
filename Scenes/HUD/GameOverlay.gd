extends Control
class_name GameOverlay

signal update

@export var player: StudentEntity:
	set(value):
		player = value
		$Control/Label.text = player.student.student_name
		#$Image/CenterPoint/Sprite2D.texture = player.student.icon
	get:
		return player
@export var timer: Timer
@export var game_logic: GameLogic
const MAX_TIME_LIMIT: int = 300 #in seconds
var hud_item_scene = preload("res://Scenes/HUD/hud_item.tscn")

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
	$Control/Control/VBoxContainer/Health/Label.text = "%s / %s" % [player.health.current_health , player.health.max_health  ]
	$Control/Control/VBoxContainer/Health.value = player.health.current_health
	$Control/Control/VBoxContainer/Health.max_value = player.health.max_health
	
	
func update_win_condition()->void:
	if timer:
		$WinConditions/ProgressBar.max_value = timer.wait_time
		$WinConditions/ProgressBar.value = timer.time_left


func _on_update():
	if player:
		for item_stack: ItemStack in player.items.get_children():
			## If there is a HudItem that already exists that contains a item_stack
			if $Items/GridContainer.get_children().any(func(node): 
				return node.item_stack.item.item_name == item_stack.item.item_name):
				var hud_item: HudItem = $Items/GridContainer.get_children().filter(func(node): 
					if node.item_stack.item.item_name == item_stack.item.item_name: return node)[0]
				#var hud_item_name = hud_item.item_stack.item.item_name
				#var item_stack_name = item_stack.item.item_name
				if hud_item is HudItem :
					if hud_item.has_method("update"):
						hud_item.item_stack = item_stack
						hud_item.update()
			else:
				var new_hud_item:= hud_item_scene.instantiate()
				new_hud_item.item_stack = item_stack
				$Items/GridContainer.add_child(new_hud_item)
