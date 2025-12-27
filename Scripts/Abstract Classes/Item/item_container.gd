extends Node
class_name Item_Container

## Description:
## The Item_Container will aide in the management of items on any entity that 
## this is equipped onto. This will have the ability to add items or increase
## the count of an extisting item.
###

signal item_stack_added
signal item_count_increased

## Quick Access to the items for outside use.
var items: Array[Item_Stack]:
	get:
		return get_children().map(func(child): return child is Item_Stack  )

## Number of Unique Items current in the container. This is NOT the total number
## of items for any given item.
var number_of_unique_items: int:
	get():
		return len(items)
		
func add_item(item: Item_Resource) -> void:
	## Check the item_container children to see if any of them have an ItemStack that contains the given Item.
	var extant_item: bool = get_children().any(func(item_stack): return item_stack.item == item)
	var item_stack: Item_Stack ## Create variable to have a count incremented on
	
	## Next steps is to check is to assign the item_stack variable either the 
	## existing item or create a new stack with the item added to it.
	if not extant_item:
		item_stack = Item_Stack.new()
		item_stack.item = item 
		add_child(item_stack)
		item_stack_added.emit()
	else:
		item_stack = get_child(get_children().find_custom(func(_item_stack): 
			return _item_stack.item == item))
	## Either item_stack creation route, we would increment the counter by 1 (either initializing, or increasing the value)
	item_stack.count += 1 
	item_count_increased.emit()
