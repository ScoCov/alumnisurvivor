class_name AbilityRapidPunch
extends Ability

var cooldown_count_down: float = 0

func _ready():
	ability = load("res://Resources/Data/Abilities/RapidPunch.tres")
	$Sprite.texture = ability.menu_image

func on_ready():
	cooldown_count_down = $Composition/Cooldown.base_value
	return true
	
func on_active(_delta):
	if $Sprite.position.x < $Composition/Range.base_value:
		$Sprite.position.x += $Composition/AttackSpeed.base_value * _delta
	else:
		return true
	return false

func on_recovery(_delta):
	if $Sprite.position.x > 0:
		$Sprite.position.x -= $Composition/AttackSpeed.base_value * _delta
	else: 
		return true
	return false

func on_cooldown(_delta):
	if cooldown_count_down > 0:
		cooldown_count_down -= 1 * _delta
	else:
		return true
	return false

