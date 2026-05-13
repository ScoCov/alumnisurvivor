class_name Menu_School_Map
extends Control

const starting_stage: Stage_Resource = preload("res://Resources/Data/Stages/stage_01.tres")

@export var stage_name: Label
@export var school_store: Menu_School_Store 
@export var detail_panel: Control
@export var shop_btn: Button
@export var description_rtf: RichTextLabel

var selected_stage: Stage_Resource:
	set(stage):
		selected_stage = stage
		update_info(stage)
		
func _ready():
	## If there is a current run in progress, use that. Otherwise, start with
	## the first stage. 
	if Global.CURRENT_RUN:
		selected_stage = load("res://Resources/Data/Stages/stage_0%s.tres" % (Global.CURRENT_RUN.current_stage_number + 1))
	else: 
		selected_stage = load("res://Resources/Data/Stages/stage_01.tres")

func update_info(stage_res: Stage_Resource):
	if detail_panel.visible == false:
		detail_panel.visible = true
	if shop_btn.visible == false and not selected_stage == starting_stage:
		shop_btn	.visible = true
	var _name: String = "Stage 0%s" % stage_res.stage_number
	stage_name.text = _name
	description_rtf.text = stage_res.description

func _on_play_pressed():
	if not Global.CURRENT_RUN:
		Global.CURRENT_RUN = Conductor.new()
	var stage_path: String = "res://Scenes/Stages/" + get_stage_number() + ".tscn"
	get_tree().change_scene_to_file(stage_path)

func get_stage_number():
	return "stage_0" + str(Global.CURRENT_RUN.current_stage_number + 1)

func _on_shop_pressed():
	school_store.visible = true

func _on_check_button_toggled(toggled_on):
	shop_btn.visible = toggled_on
