extends Node
class_name Item_Stack

signal count_changed

const MAXIMUM_STACK = 999

@export var item: Item_Resource 
@export_range(0,MAXIMUM_STACK) var count: int = 0 : 
	set(value):
		var limit: int = MAXIMUM_STACK ## 'Unlimited'
		if item.max_count > 0: ## If there is a limit at all
			limit = item.max_count
		count = clamp(value, 0, limit)
		count_changed.emit()
	get:
		if item.unique: ## If it's unique, double check and do a 
			return clamp(count, 0, 1)
		var limit: int = MAXIMUM_STACK ## 'Unlimited'
		if item.max_count > 0: ## If there is a limit at all
			limit = item.max_count
		return clamp(count, 0, limit)

func _to_string():
	return "Item: %s (x%s) " % [item.item_name, count]
