extends Ability


func _ready():
	pass

## Called when the ability is ready to be triggered again
func on_ready():
	cooldown_count = $Composition/Cooldown.value
	if target:
		$Targeting.look_at(target)
	else:
		$Targeting.look_at(get_global_mouse_position())
	return true
		
## Called when the ability is active phase
func on_active(_delta):
	if $Targeting/SwingPivot/HurtObject.position.x < 75:
		$Targeting/SwingPivot.rotation_degrees = -45
		$Targeting/SwingPivot/HurtObject.position.x = 75
	else:
		if $Targeting/SwingPivot.rotation_degrees < 45:
			$Targeting/SwingPivot.rotation_degrees += $Composition/AttackSpeed.value * _delta
		else:
			return true  
	return false
		
## Called to have the 
func on_recovery(_delta):
	if $Targeting/SwingPivot/HurtObject.position.x >= 1:
		$Targeting/SwingPivot/HurtObject.position.x = 0
	else:
		$Targeting/SwingPivot.rotation_degrees = 0
		return true  
	return false

## Called when the weapon is not doing anything and is waiting for the cooldown timer to complete.	
func on_cooldown(_delta):
	if target:
		$Targeting.look_at(target)
	else:
		$Targeting.look_at(get_global_mouse_position())
	if cooldown_count > 0:
		cooldown_count -= 1 * _delta
	else:
		return true
	return false


func _on_hitbox_body_entered(body):
	if body is EnemyEntity:
		body.emit_signal("take_damage", $Composition/Damage.value, self )
	pass # Replace with function body.
