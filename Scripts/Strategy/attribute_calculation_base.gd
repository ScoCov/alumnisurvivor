class_name AttributeCalculation
extends Node

## 
@export var player: StudentEntity
@export var attribute_component: Component

func _init(_player: StudentEntity, _attribute_component: Component):
	player = _player
	attribute_component  = _attribute_component

	
func get_value(item_bonus: ItemBonus, count: float = 0):
	pass
