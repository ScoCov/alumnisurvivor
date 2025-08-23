extends Ability

## Called when the ability is ready to be triggered again
func on_ready():
	if target: 
		$'$DirectionContainer'.look_at(target)
	else:	
		$'DirectionContainer'.look_at(get_global_mouse_position())
	cooldown_count = $'Composition/Cooldown'.value
	if cooldown_count > 0:
		return true
	return false
	
## Called when the ability is active phase
func on_active(_delta):
	$DirectionContainer/ImageContainer/Hitbox.monitoring = true
	if $DirectionContainer/ImageContainer.position.x < $Composition/Range.value:
		$DirectionContainer/ImageContainer.position.x += $Composition/AttackSpeed.value * _delta
	else:
		return true
	return false
		
## Called to have the 
func on_recovery(_delta):
	$DirectionContainer/ImageContainer/Hitbox.monitoring = false
	if $DirectionContainer/ImageContainer.position.x > 0:
		$DirectionContainer/ImageContainer.position.x -= $Composition/AttackSpeed.value * _delta
	else:
		return true
	return false

## Called when the weapon is not doing anything and is waiting for the cooldown timer to complete.	
func on_cooldown(_delta):
	if target: 
		$'$DirectionContainer'.look_at(target)
	else:
		$'DirectionContainer'.look_at(get_global_mouse_position())
	if cooldown_count > 0:
		cooldown_count -= 1 * _delta
	else:
		return true
	return false
		
		
func on_enter():
	pass
	
func on_exit():
	pass


func _on_hitbox_body_entered(body):
	if body is EnemyEntity:
		body.emit_signal("take_damage", $Composition/Damage.value, self)
