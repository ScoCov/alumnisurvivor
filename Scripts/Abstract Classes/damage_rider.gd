class_name Damage_Rider
extends Node


## The Parent Entity of the Damage Rider
@export var entity: Entity 
@export var ability: Ability_Entity
@export var damage: float = 0
@export var is_critical: bool = false
@export var critical_chance: float = 0
@export var critical_damage_multiplier: float = 0
@export var ignore_armor: float = 0
@export var items: Item_Container = null

func _init(_entity: Entity, _ability: Ability_Entity, _items: Item_Container = null):
	entity = _entity
	ability = _ability
	items = _items

func deal_damage(armor_value: float = 0, direct_damge_reduction: int = 0) -> int:
	## Check if Crit
	var damage_total: float = 0
	critical_chance = (ability.ability.critical_hit_chance + items.get_attribute_bonus("critical_chance"))
	var _critical_hit = randf_range(0,1) < critical_chance
	damage_total += ability.ability.base_damage + (ability.ability.base_damage * items.get_attribute_bonus("damage"))
	if _critical_hit:
		critical_damage_multiplier = ability.ability.critical_damage_multiplier + items.get_attribute_bonus("critical_damage")
		damage_total *= critical_damage_multiplier
		is_critical = _critical_hit
	if armor_value != 0:
		var armor_reduction_percentage = armor_value/(armor_value+100)
		damage_total *= armor_reduction_percentage
	damage = floori(damage_total)
	damage -= direct_damge_reduction
	if damage < 1:
		damage = 1
	return floori(damage)
