class_name Level_Up_Menu
extends Control

signal menu_triggered
signal game_resumed
signal object_chosen
signal reroll
signal ban
signal skip

@export var game_ui: Game_Ui
@onready var level_up_points = $"Title/Level Up Points"
@onready var h_box_container = $Body/MarginContainer/HBoxContainer

func _get_configuration_warnings():
	var msg: Array[String]
	if not game_ui:
		msg.append("Level Up Menu Requires a Game UI object to opwerate.")
	return msg

func _ready():
	var card_items: Array[Node] = h_box_container.get_children().filter(func(child): return child is Item_Display)
	for card: Item_Display in card_items:
		card.picked.connect(card_picked.bind(card))
	card_items[0].grab_focus()
	
func _on_skip_pressed():
	game_ui.game_logic.skip_counter -= 1
	skip.emit()
	game_ui.display_game_ui()
	
func update():
	ui_information()

func ui_information():
	level_up_points.text = "+%s" % game_ui.player.experience.level_up_points
	_update_options_button("Reroll")

	
func randomize_options():
	var card_items: Array[Node] = h_box_container.get_children().filter(func(child): return child is Item_Display)
	for card: Item_Display in card_items:
		card.assign_item(_get_item())
	var rand_focus_index: int = randi_range(0, len(card_items) - 1)
	ui_information()

func _update_options_button(target: String):
	var game_logic: Game_Local = game_ui.game_logic
	var counter = game_logic[str(target.to_lower(), "_counter")]
	var text = str("+" ,counter) if counter > 0 else ""
	var child = $Options/MarginContainer/HBoxContainer
	var target_child = child.find_child(target).find_child("Label")
	(child.find_child(target) as Button).disabled = false if counter > 0 else true
	target_child.text = text

func card_picked(_item_display: Item_Display):
	game_ui.player.items.add_item(_item_display.item)
	object_chosen.emit()
	game_ui.player.experience.level_up_points -= 1
	if game_ui.player.experience.level_up_points < 1:
		game_ui.display_game_ui()
	else:
		randomize_options()

func _on_menu_triggered():
	randomize_options()

func _get_item() -> Item_Resource:
	var _item: Item_Resource
	var item_pool = get_item_pool()
	var rand_index = randi_range(0, len(item_pool) - 1)
	_item = item_pool[rand_index]
	if _item.unique:
		if game_ui.player.items._items.has(_item.item_id):
			_item = _get_item()
	if _item.max_count != 0:
		var temp = game_ui.player
		if game_ui.player.items._items.has(_item.item_id):
			if game_ui.player.items._items[_item.item_id].count >= _item.max_count:
				_item = _get_item()
	if _item in h_box_container.get_children().map(func(it: Item_Display): return it.item):
		_item = _get_item()
		
	return _item
	
func get_item_pool() -> Array[Item_Resource]:
	var random_item_pool: Array[Item_Resource]
	var rand_roll = randf_range(0.001, 1)
	if rand_roll <= Item_Rarity.get_spawn_chance(Item_Rarity.rarity.Legendary):
		random_item_pool = Global.ITEM_COLLECTION.filter(func(item: Item_Resource): return item.rarity == Tags.Rarity.Legendary)
	elif rand_roll <= Item_Rarity.get_spawn_chance(Item_Rarity.rarity.Rare):
		random_item_pool = Global.ITEM_COLLECTION.filter(func(item: Item_Resource): return item.rarity == Tags.Rarity.Rare)
	elif rand_roll <= Item_Rarity.get_spawn_chance(Item_Rarity.rarity.Uncommon):
		random_item_pool = Global.ITEM_COLLECTION.filter(func(item: Item_Resource): return item.rarity == Tags.Rarity.Uncommon)
	else:
		random_item_pool = Global.ITEM_COLLECTION.filter(func(item: Item_Resource): return item.rarity == Tags.Rarity.Common)
	return random_item_pool
	
func _get_item_by_index(index: int) -> Item_Resource:
	return Global.ITEM_COLLECTION[index]
	
func _get_item_by_id(id: String) -> Item_Resource:
	return Global.ITEM_COLLECTION[Global.ITEM_COLLECTION.find_custom(func(child:Item_Resource): return child.item_id == id)]
	
func _rand_item_index() -> int:
	if len(Global.ITEM_COLLECTION) >=1:
		return randi_range(0,len(Global.ITEM_COLLECTION) -1)
	return -1

func _on_reroll_pressed():
	game_ui.game_logic.reroll_counter -= 1
	randomize_options()
	reroll.emit()

func _on_ban_pressed():
	game_ui.game_logic.ban_counter -= 1
	randomize_options()
	ban.emit()
