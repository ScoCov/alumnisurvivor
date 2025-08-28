extends Node
class_name ItemManager

signal item_stack_added

@export var player: StudentEntity

## Add a given Item to the ItemManager in the form of an ItemStack. If the Item (and ItemStack) already exists,
## this function will then increase that ItemStack's count by 1. 
## This function will also return a Dictionary of {Item: item_stack.item.item_name, Count: item_stack.count}
func add_item(item: ItemResource) -> Dictionary:
	## Check the ItemManager's children to see if any of them have an ItemStack that contains the given Item.
	var extant_item: bool = get_children().any(func(item_stack): return item_stack.item == item)
	print("Item is Extant: %s " % extant_item)
	var item_stack: ItemStack
	
	## If extant_item then use that ItemStack, otherwise; make a new ItemStack with the appropriate item.
	if not extant_item:
		item_stack = ItemStack.new()
		item_stack.item = item 
		add_child(item_stack)
		item_stack_added.emit()
	else:
		item_stack = get_children().filter(func(_item_stack): return _item_stack.item.item_name == item.item_name)[0]
		
	item_stack.count += 1 
	print("Item stack: %s %s" % [item_stack.item.item_name, str(item_stack.count)])
	item_stack.count_changed.emit()
	calculate_attributes(player)
	return {"Item": item.item_name, "Count": item_stack.count} ## show the results of the additional item.
	
	
func get_item_by_name(item_name: String) -> ItemStack:
	return get_children().filter(func(item_stack: ItemStack): return item_stack.item.item_name == item_name)[0]
	
func get_item_by_id(item_id: String) -> ItemStack:
	return get_children().filter(func(item_stack: ItemStack): return item_stack.item.item_id == item_id)[0]
	
func get_item_by_item_resource(item: ItemResource) -> ItemStack:
	return get_children().filter(func(item_stack: ItemStack): return item_stack.item == item)[0]

## When there's an update to any of the children (a new item or increased itemstack count) 
## will trigger the updating of the player's stats.
func calculate_attributes(player: StudentEntity)-> void:
	## For each ItemStack in the ItemManger, find if there's 
	## a composition on the player that is effected by one of the 
	## Item's ItemBonus. 
	if not player:return
	for item_stack: ItemStack in get_children():
		for attribute: Component in player.get_node("Composition").get_children():
			for item_bonus: ItemBonus in item_stack.item.bonuses:
				
				if attribute.attribute.id == item_bonus.attribute.id:
					print("WE GOT IT")
