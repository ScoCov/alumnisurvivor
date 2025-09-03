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
	#print("Item stack: %s %s" % [item_stack.item.item_name, str(item_stack.count)])
	item_stack.count_changed.emit()
	calculate_attributes()
	return {"Item": item.item_name, "Count": item_stack.count} ## show the results of the additional item.
	
	
func get_item_by_name(item_name: String) -> ItemStack:
	return get_children().filter(func(item_stack: ItemStack): return item_stack.item.item_name == item_name)[0]
	
func get_item_by_id(item_id: String) -> ItemStack:
	return get_children().filter(func(item_stack: ItemStack): return item_stack.item.item_id == item_id)[0]
	
func get_item_by_item_resource(item: ItemResource) -> ItemStack:
	return get_children().filter(func(item_stack: ItemStack): return item_stack.item == item)[0]

## When there's an update to any of the children (a new item or increased itemstack count) 
## will trigger the updating of the player's stats.
func calculate_attributes()-> void:
	## Each Item Bonus will effect a differnt attribute, or give a different function.
	## Go through the items, get the item_bonuses, find the compositions on the player
	## that matches a composition attribute. Then, on that composition, apply the 
	## modded attribute to the player. 
	if not player: return
	for child in player.get_node("Composition").get_children():
		child.clear() ## Clear out all of the Components
	for item_stack: ItemStack in get_children():
		var item: ItemResource = item_stack.item
		for bonus: ItemBonus in item.bonuses:
			var player_attribute = player.get_node("Composition").get_children().filter(func(comp: Component):
				return comp if comp.attribute.id == bonus.attribute.id else null)
			if player_attribute:
				player_attribute = player_attribute[0]
				var att_calc: AttributeCalculation = AddToMod.new(player, player_attribute)
				att_calc.get_value(bonus, item_stack.count)
				print("player attribute: %s" % player_attribute.id)
				continue
	
