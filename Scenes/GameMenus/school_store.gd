class_name Menu_School_Store
extends Control

@export var back_btn: Button
@export var skip_btn: Button
@export var credits_label: Label
@export var levels_label: Label
@export var stage_label: Label
@export var shop_items: Store_Items
@export var shop_abilities: Store_Abilities


@onready var selection = $Selection

var stage: Stage_Resource

func _ready():
	var load_string = "res://Resources/Data/Stages/stage_0" 
	if Global.CURRENT_RUN:
		load_string +=  str(Global.CURRENT_RUN.current_stage_number + 1) + ".tres"
		credits_label.text = "Credits: %s" % Global.CURRENT_RUN.credits
		levels_label.text = "Levels: %s" % Global.CURRENT_RUN.experience.level_up_points
	else:
		load_string += "1.tres" 
	stage = load(load_string)
	stage_label.text = "%s (0%s)" % [stage.stage_name, stage.stage_number]
	shop_items.generate_items.emit()

func _on_skip_pressed():
	self.visible = false

func _on_level_shop_pressed():
	skip_btn.visible = false
	shop_items.get_parent().visible = false
	shop_abilities.get_parent().visible = true
	back_btn.visible = true
	selection.visible = false
	
func _on_credit_shop_pressed():
	skip_btn.visible = false
	shop_items.get_parent().visible = true
	shop_abilities.get_parent().visible = false
	back_btn.visible = true
	selection.visible = false

func _on_back_pressed():
	skip_btn.visible = true
	shop_items.get_parent().visible = false
	shop_abilities.get_parent().visible = false
	back_btn.visible = false
	selection.visible = true
