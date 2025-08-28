class_name AddToBase
extends AttributeCalculation

func get_value(item_bonus: ItemBonus, count: float = 0):
	attribute_component.base_mod += item_bonus.start_value + (count * item_bonus.growth_modifier)
	
