class_name Store_Items
extends Control

@warning_ignore("unused_signal")
signal generate_items

@export var container: HBoxContainer

func _ready():
	for card: Item_Display in container.get_children():
		card.picked.connect(buy_item.bind(card))

##TODO: I want a more sophisticated way to generate items. Right now, it's purely
## random generation and I would like some sort of influence for said item-types.
func _on_generate_items():
	for card: Item_Display in container.get_children():
		card.item = Global.ITEM_COLLECTION[randi_range(0, len(Global.ITEM_COLLECTION) - 1)]

## Attempt to buy item from the given Item_Display. If successful, makes the 
## Item_Display go invisible and takes the appropriate amount of  credits away
## from CURRENT_RUN.credits. 
func buy_item(item_display: Item_Display) -> bool:
	if Global.CURRENT_RUN.credits < item_display.item.base_cost: return false
	Global.CURRENT_RUN.credits -= item_display.item.base_cost * (1.00 + (Global.CURRENT_RUN.current_stage_number * 0.20))
	Global.CURRENT_RUN.items.add_item(item_display.item)
	item_display.visible = false
	return true
