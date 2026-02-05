class_name Item_Effect_Attribute
extends Item_Effect

@export var attribute: AttributeResource
## Base Value will contain either the flat amount or percentage. This can be determined by whether or not something is greater than 1. (Will need
## more robustness.
@export var base_value: float = 0
## Base Stack Mod will be used to calculate the modifications to be added onto the base value, which 
## the value is determined by the stack count multiplied by this value. 
@export var base_stack_mod: float = 0


func _to_string() -> String:
	var msg: String = "%s: %s" % [attribute.name, base_value,]
	return msg

## Keeping this in for now as it serves a a purpose in the level up menu. I plan to update this away later.
func get_info_row() -> String:
	return str(self)
