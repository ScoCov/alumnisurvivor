class_name StrategyThrust
extends StrategyAttackType

func active(weapon_entity: WeaponEntity, _delta: float) -> bool:
	weapon_entity.cooldown_complete = false
	weapon_entity.get_node('Marker2D/Sprite2D').position.x += weapon_entity.ability.attack_speed * _delta
	if (weapon_entity.get_node('Marker2D/Sprite2D').position.x >= weapon_entity.ability.attack_range * 
	(0.5 if weapon_entity.ability.attack_type == "Melee" else 1)):
		return true
	return false
	
func recover(weapon_entity: WeaponEntity, _delta: float) -> bool:
	weapon_entity.get_node('Marker2D/Sprite2D').position.x -= weapon_entity.ability.attack_speed * _delta
	if weapon_entity.get_node('Marker2D/Sprite2D').position.x < 0.1:
		weapon_entity.get_node('Marker2D/Sprite2D').position.x = floor(0)
		return true
	return false
	
func cooldown(weapon_entity: WeaponEntity, _delta: float) -> bool:
	return weapon_entity.cooldown_complete
	
func cooldown_timeout(weapon_entity: WeaponEntity):
	weapon_entity.cooldown_complete = true
	
func ready(weapon_entity: WeaponEntity, _delta: float) -> bool:
	weapon_entity.get_node('CooldownTimer').wait_time = weapon_entity.ability.cooldown
	weapon_entity.cooldown_complete = false
	return !weapon_entity.cooldown_complete
