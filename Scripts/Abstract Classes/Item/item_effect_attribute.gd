class_name Item_Effect_Attribute
extends Item_Effect

@export var attribute: AttributeResource
## Base Increase will directly add to the base stats of the ability/component being used.
@export var base_value: float
## Base Stack Mod will be used to calculate the modifications to be added onto the base value, which 
## the value is determined by the stack count multiplied by this value. 
@export var base_stack_mod: float
## The amount to modify the base values by via a percentage amount. Percentage values will be summed up into one and applied at once. 
@export var percentage_value: float 
## Percentage Stack Mod will be used to calculate the modifications to be added onto the percentage value,
## which the value is determined by the stack count multiplied by this value.
@export var percentage_stack_mod: float


func _to_string() -> String:
	var msg: String = "%s: %s" % [attribute.name, base_value if base_value else "%s" % [percentage_value]]
	return msg

## Keeping this in for now as it serves a a purpose in the level up menu. I plan to update this away later.
func get_info_row() -> String:
	return str(self)
