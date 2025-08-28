class_name AddToMod
extends AttributeCalculation

func get_value(item_bonus: ItemBonus, count: float = 0):
	attribute_component.mod_value += item_bonus.start_value + (count * player.experience.level)
