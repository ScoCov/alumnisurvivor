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

func _get_configuration_warnings():
	var msg: Array[String]
	if not get_parent() is Ability_Entity:
		msg.append("Damage Component can only be assigned to an Ability Entity.")
	return msg

## Deal Damage will accumilate all the damage bonus modifiers, while the health components
## attempt_damage function will apply any all all defensive measures.
#func deal_damage(_enemy_health: Health_Component, _params: Dictionary) -> float:
	#var damage_amount: float = _get_damage()
	#if _params.has("item_add"):
		#damage_amount += _params["item_add"]
	#if _params.has("item_multi"):
		#damage_amount *= _params["item_multi"]
	#var student_besty: float = 0
	#
	#if _params.has("student_primary"):
		#student_besty += _params["student_primary"]
	#if _params.has("student_secondary"):
		#student_besty += _params["student_secondary"]
	#if _params.has("besty_primary"):
		#student_besty += _params["besty_primary"]
	#if _params.has("besty_secondary"):
		#student_besty += _params["besty_secondary"]
	#if _params.has("student_weakness"):
		#student_besty -= _params["student_weakness"]
	#if _params.has("besty_weakness"):
		#student_besty -= _params["besty_weakness"]
	#return damage_amount * (1 + student_besty)
	
#func _get_damage() -> float:
	#return randi_range(floor(min_damage),floor(max_damage)) if enable_ranged_damage else base_damage
