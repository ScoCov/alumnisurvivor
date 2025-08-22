extends Node
class_name ItemManager

signal item_stack_added

var attributes: Dictionary

## Add a given Item to the ItemManager in the form of an ItemStack. If the Item (and ItemStack) already exists,
## this function will then increase that ItemStack's count by 1. 
## This function will also return a Dictionary of {Item: item_stack.item.item_name, Count: item_stack.count}
func add_item(item: ItemResource):
	## Check the ItemManager's children to see if any of them have an ItemStack that contains the given Item.
	var extant_item: bool = get_children().any(func(item_stack): return item_stack.item.item_name == item.item_name)

	if extant_item: ## If the ItemStack exists with the given Item, then incease the ItemStack's count.
		var item_stack: ItemStack = get_children().filter(func(_item_stack): return _item_stack.item.item_name == item.item_name)[0]
		item_stack.count +=1 
		item_stack.count_changed.emit()
		modify_attributes() ## This should technically be moved out of this class to be assigned to the signals.
		return {"Item": item.item_name, "Count": item_stack.count} ## Exit function early.
		
	var new_item_stack:= ItemStack.new()
	new_item_stack.item = item
	new_item_stack.count = 1
	add_child(new_item_stack)
	item_stack_added.emit()
	modify_attributes()
	return {"Item": new_item_stack.item.item_name, "Count": new_item_stack.count}
	
func _ready():
	if get_child_count() > 0:
		print('Item Debug Mode is Active')


## This function is to be called everytime an item is either added to the manager, or
## if an itemstack's count is increased.
func modify_attributes():
	attributes = {} ## Clear the Dictionary if there's anything in there. Rebuild from scratch to prevent runnaway accidents.
	
	for item_stack in get_children():
		if item_stack is ItemStack:
			var item:= item_stack.item as ItemResource
			if not item:
				return false
				
			for bonus in item.bonuses:
				if !attributes.has(bonus.attribute.id):
					attributes[bonus.attribute.id] = bonus.start_value + (bonus.growth_modifier * (item_stack.count - 1))
					continue ## If we added it, then go onto the next bonus. 
				attributes[bonus.attribute.id] += bonus.start_value + (bonus.growth_modifier * (item_stack.count - 1))
		
