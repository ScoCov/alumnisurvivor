class_name Damage_Rider
extends Node

signal damage_dealt

## The Parent Entity of the Damage Rider
@export var entity: Entity 
@export var ability: Ability_Entity
@export var damage: float = 0
@export var is_critical: bool = false
@export var critical_chance: float = 0
@export var critical_damage_multiplier: float = 0
@export var ignore_armor: float = 0
@export var items: Item_Container = null
@export var direction: Vector2

func _init(_entity: Entity, _ability: Ability_Entity, _items: Item_Container = null):
	entity = _entity
	ability = _ability
	items = entity.items

func deal_damage() -> int:
	## Check if Crit
	var damage_total: float = 0
	var crit_item =  items.get_attribute_bonus("critical_chance")
	var _critical_hit = randf_range(0,1) < critical_chance
	var damage_item = items.get_attribute_bonus("damage")
	var crit_damage_item = items.get_attribute_bonus("critical_damage")
	
	if ability:
		critical_chance = (ability.ability.critical_hit_chance + crit_item)
		damage_total += ability.ability.base_damage + (ability.ability.base_damage * (1 + damage_item))
	if _critical_hit and ability:
		critical_damage_multiplier = ability.ability.critical_damage_multiplier + crit_damage_item
		damage_total *= critical_damage_multiplier
		is_critical = _critical_hit
	damage = floori(damage_total)
	if damage < 1:
		damage = 1
		
	damage_dealt.emit()
	return floori(damage)
	
func deal_knockback() -> float:
	if not ability: return 0.0
	return ability.ability.knockback + entity.items.get_attribute_bonus("knockback")
	
