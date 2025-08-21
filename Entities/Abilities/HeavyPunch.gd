class_name AbilityHeavyPunch
extends Ability

var cooldown_count_down: float = 0

func _ready():
	ability = load("res://Resources/Data/Abilities/HeavyPunch.tres")
	$Pivot/Sprite.texture = ability.menu_image
	($Pivot/Sprite as Sprite2D).rotate(0.90)

func on_ready():
	var pivot = $Pivot as Marker2D
	pivot.rotation_degrees = -45
	cooldown_count_down = $Composition/Cooldown.base_value
	return true
	
func on_active(_delta):
	$'Pivot/Sprite'.visible = true
	var pivot = $Pivot as Marker2D
	$Pivot/Sprite.position.x  = $Composition/Range.base_value
	if pivot.rotation_degrees < 45:
		pivot.rotation_degrees += $Composition/AttackSpeed.base_value * _delta
	else:
		return true
	return false

func on_recovery(_delta):
	$Pivot/Sprite.position.x = $Composition/AttackSpeed.base_value 
	$'Pivot/Sprite'.visible = false
	return true

func on_cooldown(_delta):
	if cooldown_count_down > 0:
		cooldown_count_down -= 1 * _delta
	else:
		return true
	return false
