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
@export var direction: Vector2

func _init(_entity: Entity, _ability: Ability_Entity, _items: Item_Container = null):
	entity = _entity
	ability = _ability
	items = _items

func deal_damage() -> int:
	## Check if Crit
	var damage_total: float = 0
	critical_chance = (ability.ability.critical_hit_chance + items.get_attribute_bonus("critical_chance") if self.has_node("items") else 0)
	var _critical_hit = randf_range(0,1) < critical_chance
	damage_total += ability.ability.base_damage + (ability.ability.base_damage * items.get_attribute_bonus("damage")  if items else 0)
	if _critical_hit:
		critical_damage_multiplier = ability.ability.critical_damage_multiplier + items.get_attribute_bonus("critical_damage")  if items else 0
		damage_total *= critical_damage_multiplier
		is_critical = _critical_hit
	damage = floori(damage_total)
	if damage < 1:
		damage = 1
	return floori(damage)
	
