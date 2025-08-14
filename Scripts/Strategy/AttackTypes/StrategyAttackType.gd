class_name StrategyAttackType
extends Node

func active(weapon_entity: WeaponEntity, _delta: float) -> bool:
	return false
	
func recover(weapon_entity: WeaponEntity, _delta: float) -> bool:
	return false
	
func cooldown(weapon_entity: WeaponEntity, _delta: float) -> bool:
	return false
	
func cooldown_timeout(weapon_entity: WeaponEntity):
	pass
	
func ready(weapon_entity: WeaponEntity, _delta: float) -> bool:
	return false
	
