extends Node
class_name ItemManager

signal item_stack_added

@export var player: StudentEntity

func _ready():
	assert(player, "There must be a player for the ItemManager to work.")

## Add a given Item to the ItemManager in the form of an ItemStack. If the Item (and ItemStack) already exists,
## this function will then increase that ItemStack's count by 1. 
## This function will also return a Dictionary of {Item: item_stack.item.item_name, Count: item_stack.count}
func add_item(item: ItemResource) -> void:
	## Check the ItemManager's children to see if any of them have an ItemStack that contains the given Item.
	var extant_item: bool = get_children().any(func(item_stack): return item_stack.item == item)
	var item_stack: ItemStack
	
	## If the item is already an ItemStack, move to the next step;
	## Otherwise, make a new ItemStack with the appropriate item.
	if not extant_item:
		item_stack = ItemStack.new()
		item_stack.item = item 
		add_child(item_stack)
		item_stack_added.emit()
	else:
		item_stack = get_children().filter(func(_item_stack): 
			return _item_stack.item.item_name == item.item_name)[0]
	
	item_stack.count += 1 
	
func get_item_by_name(item_name: String) -> ItemStack:
	return get_children().filter(func(item_stack: ItemStack): return item_stack.item.item_name == item_name)[0]
	
func get_item_by_id(item_id: String) -> ItemStack:
	return get_children().filter(func(item_stack: ItemStack): return item_stack.item.item_id == item_id)[0]
	
func get_item_by_item_resource(item: ItemResource) -> ItemStack:
	return get_children().filter(func(item_stack: ItemStack): return item_stack.item == item)[0]

	
