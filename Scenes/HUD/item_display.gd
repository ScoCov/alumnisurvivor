class_name Item_Display
extends Control

signal picked

@export var item: Item_Resource:
	set(_item):
		item = _item
		render_item_information(_item)
	get():
		return item
		
@onready var item_name = $"Title/Item Name"
@onready var display_image = $ImageContainer/Center/DisplayImage
@onready var info_sorter = $Information/MarginContainer/InfoSorter
@onready var group = $Tags/Group
@onready var rarity = $Tags/Rarity
@onready var limit = $Title/Limit
@onready var pick = $Pick


func _get_configuration_warnings():
	var msg: Array[String]
	if not item:
		msg.append("Item Display requires an Item Resource.")
	return msg

func _ready():
	pass

func render_item_information(_item: Item_Resource = null):
	if info_sorter.get_child_count() > 0:
		for child in info_sorter.get_children(): 
			child.queue_free()
	item_name.text = item.item_name
	display_image.texture = item.image
	if Global.CURRENT_RUN:
		pick.text = "BUY: %s-Credits" % (_item.base_cost * (1+ceil(_item.base_cost * Global.CURRENT_RUN.current_stage_number)))
	else:
		pick.text = "BUY: %s-Credits" % _item.base_cost 
	group.text = Tags.Group.keys()[item.group_tags]
	limit.text = ""
	if item.unique:
		limit.text = "Unique"
	if item.max_count != 0:
		var current_item_count = "0"
		limit.text = "%s/%s" % [current_item_count, item.max_count]
	for item_effect: Item_Effect in item.item_effects:
		info_sorter.add_child(get_info_row(item_effect))

func _on_pick_pressed():
	picked.emit()
	return item
		
func get_info_row(item_effect: Item_Effect) -> Control:
	var row:= Label.new()
	row.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	row.add_theme_font_size_override("font_size", 13)
	row.text = item_effect.get_info_row()
	return row

func assign_item(_item: Item_Resource):
	item = _item
	render_item_information()

func _on_loaded():
	render_item_information()
