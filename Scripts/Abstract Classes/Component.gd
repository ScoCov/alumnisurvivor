class_name Component
extends Node


## Use to create minimum stats for a given enti y to function. This value should never be altered 
## after creation. Unless it is a specific effect to modifiy the base - which further logic will be needed.
@export var base_value: float

## Value that is to be added on top of the base_value. If altering the entity's stats this is the value that new alteration should be assigned.
var mod_value: float

## This is the value that should be called when used by an entity. It contains the attribute limitation
## logic. Base and Mod values are meant to remain unlimited for purposes of recording and potential 
## use in the future.
var value: float:
	set(wontuse):
		pass
	get:
		var return_value = base_value + mod_value
		if attribute:
			if attribute.min_limit_active and return_value < attribute.min_limit:
				return_value = attribute.min_limit
			if attribute.max_limit_active and return_value > attribute.max_limit:
				return_value = attribute.max_limit
		return return_value


@export_group("Custom Attribute")
## If custom limitations on an attribute need to be applied, add the attribute and its' limitations
## to this variable. Otherwise, the custom Attribute+Component classes will automatically assign their
## appropriate attribute.
@export var attribute: AttributeResource


