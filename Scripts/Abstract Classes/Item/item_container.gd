extends Node
class_name Item_Container

## Description:
## The Item_Container will aide in the management of items on any entity that 
## this is equipped onto. This will have the ability to add items or increase
## the count of an extisting item.
###

signal item_stack_added
signal item_count_increased
		
var _items: Dictionary = {}
var _attributes: Dictionary
		
func add_item(item: Item_Resource) -> void:
	## Check the item_container children to see if any of them have an ItemStack that contains the given Item.
	var extant_item: bool = get_children().any(func(_item_stack): return _item_stack.item == item)
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
	_add_to_item_dictionary(item_stack)
	_attributes_to_dict(item_stack)
	item_count_increased.emit()
	

func _add_to_item_dictionary(_item_stack: Item_Stack):
	var dict_item = _items.get(_item_stack.item.item_id)
	if dict_item:
		dict_item.count = _item_stack.count
	else:
		_items.get_or_add(_item_stack.item.item_id, { "count": _item_stack.count,"item": {"item_effects": _item_stack.item.item_effects}} )
	
func _attributes_to_dict(_item_stack: Item_Stack):
	# Get Item effects that are attribute related. Isolate those effects.
	for iea: Item_Effect_Attribute in _item_stack.item.item_effects.filter(func(eff): return eff is Item_Effect_Attribute):
		## Get Attribute, Base Value, Growth Value, and then get the count of the item. 
		var attr = _attributes.get_or_add(iea.attribute.id, {"items":[]})
		if attr.items.any(func(obj): return obj.has(_item_stack.item.item_id)):
			var _item_index =  attr.items.find_custom(func(obj): return obj.has(_item_stack.item.item_id))
			attr.items[_item_index].assign(create_dict_row(_item_stack, iea))
		else:
			attr.items.append(create_dict_row(_item_stack, iea))
				
## Returns the value to be treated as the singular [item_bonus] on abilities and actions. 
func get_attribute_bonus(attribute_id: String) -> float:
	var attr = _attributes.get(attribute_id)
	var sum: float = 0
	if not attr: return 0
	for obj in attr.items:
		sum += (obj.growth_value * obj.count)
	return sum

func create_dict_row(_item_stack: Item_Stack, iea: Item_Effect_Attribute) -> Dictionary:
	var _item = _item_stack.item
	return {_item.item_id: _item, "count": _item_stack.count, "base_value": iea.base_value , "growth_value": iea.base_stack_mod}
