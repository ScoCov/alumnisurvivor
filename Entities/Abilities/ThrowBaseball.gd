extends Ability


var projectile_scene: PackedScene = preload("res://Entities/Projectile.tscn")

func _ready():
	cooldown_count = $Composition/Cooldown.value

func on_ready():
	if cooldown_count < 1:
		cooldown_count = $Composition/Cooldown.value
	return true if cooldown_count >= 1 else false
	
func on_active(_delta):
	var new_projectile: Projectile =  projectile_scene.instantiate()
	new_projectile.source_entity = player
	new_projectile.parent_ability = self
	#new_projectile.position = player.position + player.get_parent().position
	new_projectile.position = player.position 
	new_projectile.target_direction = self.position.direction_to(get_local_mouse_position())
	if player:
		player.global_projectile_container.add_child(new_projectile)
		return true
	else:
		new_projectile.position = Vector2()
		add_child(new_projectile)
		return true
	
func on_recovery(_delta):
	return true
	
func on_cooldown(_delta):
	if cooldown_count > 0:
		cooldown_count -= 1 * _delta
		return false
	else:
		return true
