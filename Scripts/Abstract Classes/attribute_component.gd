class_name Component
extends Node


## The value will be the end result in which the modifier component will add,
## multiply, subract, or divide the given attribute of an ability or entity.
var value: float

@export var entity: CharacterBody2D

## Hold the data for which attribute this component controls and edits.
@export var attribute_resource: AttributeResource

## Place the item_stacks that are associated with the upgrades. 
## Check for item_stack_count accuracy from student entity's 'items' property.
@export var item_stacks: Array[ItemStack]
