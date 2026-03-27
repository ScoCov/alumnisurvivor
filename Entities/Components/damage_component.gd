class_name Damage_Component
extends Node

## Description
## The Damage component will only ever be on Abilities. This includes touch damage abilities form entities.
## The only thing Damage component should be doing is accepting default values. Then 
## when it's time for damage to calculate the total damage that would be dealt before any mitigation 
## would occur; which, would be handled by the health component of the entity.

@export var enable_ranged_damage: bool = false
@export var base_damage: float = 1
## If base damage is not the values used for calculations will be determined
## randomly between min and max damage 
@export var min_damage: float = 0
@export var max_damage: float = 0

## All hits will have a chance to apply a critical hit of minimum 3% to start.
@export var critical_hit_chance: float = 0.03
@export var critical_damage_multiplier: float = 1.8

@export var knockback: float = 0

func get_damage() -> Dictionary:
	var is_crit = false
	var _items = gather_items()
	var _item_boost_damage = 0
	var _item_boost_crit_chance = 0
	var _item_boost_crit_multiplier = 0
	if _items:
		_item_boost_damage = _items.get_attribute_bonus("damage")
		_item_boost_crit_chance = _items.get_attribute_bonus("critical_chance")
		_item_boost_crit_multiplier = _items.get_attribute_bonus("critical_damage")
	var damage_boosted = base_damage * (1 + _item_boost_damage)
	var total_chance = critical_hit_chance * (1 + _item_boost_crit_chance)
	var total_multi = critical_damage_multiplier + _item_boost_crit_multiplier
	if randf_range(0, 1) <= total_chance:
		damage_boosted *= total_multi
		is_crit = true
	return Dictionary({"damage": floori(damage_boosted),"is_crit": is_crit})
	
func gather_items() -> Item_Container:
	var index: int = get_parent().get_children().any(func(child): child is Item_Container)
	if index >= 0:
		return get_parent().get_children()[index]
	return null
