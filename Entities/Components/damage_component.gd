class_name Damage_Component
extends Node

@export var ability: Ability_Entity

@export var base_damage: float = 1
@export var minimum_damage: float = 0
@export var maximum_damage: float = 0
@export var critical_hit_chance: float = 0.03
@export var critical_damage_multiplier: float = 1.8


func _ready():
	if ability.get_property_list().any(func(abil): return abil.name == "base_damage"):
		print("base_damage_detected")
		base_damage = ability["base_damage"]
	pass

### Source should be an Ability. The Target should be either an Enemy Entity or a Student Entity
func attempt_to_deal_damage(_source: Variant, target: Variant) -> float:
	#assert(source is Ability, "source must be an ability")
	assert((target is Enemy_Entity or target is Student_Entity), "Damage Component, attempt to deal damage, requires target to be Student_Entity or Enemy_Entity")
	var end_damage_value: float = 0
	return end_damage_value
	
