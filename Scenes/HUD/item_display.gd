class_name Item_Display
extends Control

signal picked
signal rendered

@export var item: Item_Resource
@onready var item_name = $"Item Name"
@onready var display_image = $ImageContainer/Center/DisplayImage
@onready var info_sorter = $Information/MarginContainer/InfoSorter

func _ready():
	render_item_information()

func render_item_information():
	item_name.text = item.item_name
	display_image.texture = item.image
	for item_effect: Item_Effect in item.item_effects:
		info_sorter.add_child(get_info_row(item_effect))
	rendered.emit() ## keep at the end

func _on_pick_pressed():
	picked.emit()

func refresh_card(_item: Item_Resource):
	if item != _item:
		item = _item
		render_item_information()
		
func get_info_row(item_effect: Item_Effect) -> Control:
	var row:= Label.new()
	row.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	row.add_theme_font_size_override("font_size", 13)
	row.text = item_effect.get_info_row()
	## Fill out info
	return row
