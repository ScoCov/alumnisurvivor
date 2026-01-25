class_name Item_Display
extends Control

signal picked
signal rendered

@export var item: Item_Resource:
	set(_item):
		item = _item
		refresh_card(_item)
	get():
		return item
		
@export var level_up_menu: Level_Up_Menu

@onready var item_name = $"Title/Item Name"
@onready var display_image = $ImageContainer/Center/DisplayImage
@onready var info_sorter = $Information/MarginContainer/InfoSorter
@onready var group = $Tags/Group
@onready var rarity = $Tags/Rarity
@onready var limit = $Title/Limit


func _get_configuration_warnings():
	var msg: Array[String]
	if not item:
		msg.append("Item Display requires an Item Resource.")
	return msg

func _ready():
	render_item_information()

func render_item_information(_item: Item_Resource = null):
	if not item: return
	if info_sorter.get_child_count() > 0:
		for child in info_sorter.get_children(): 
			child.queue_free()
	item_name.text = item.item_name
	display_image.texture = item.image
	group.text = Tags.Group.keys()[item.group_tags]
	#rarity.text = Tags.Rarity.keys()[item.rarity]
	limit.text = ""
	if item.unique:
		limit.text = "Unique"
	if item.max_count != 0:
		var player_item = level_up_menu.game_ui.player.items._items.has(item.item_id)
		var current_item_count = "0"
		if player_item:
			current_item_count = "%s" % level_up_menu.game_ui.player.items._items[item.item_id].count
		limit.text = "%s/%s" % [current_item_count, item.max_count]
	for item_effect: Item_Effect in item.item_effects:
		info_sorter.add_child(get_info_row(item_effect))
	$Border.modulate = Item_Rarity.get_rarity_color(item.rarity)
	rendered.emit() ## keep at the end

func _on_pick_pressed():
	picked.emit()

func refresh_card(_item: Item_Resource):
	render_item_information(_item)
		
func get_info_row(item_effect: Item_Effect) -> Control:
	var row:= Label.new()
	row.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	row.add_theme_font_size_override("font_size", 13)
	row.text = item_effect.get_info_row()
	return row

func assign_item(_item: Item_Resource):
	item = _item
	render_item_information()


func _on_focus_entered():
	$Pick.grab_focus()
