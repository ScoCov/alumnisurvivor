class_name AbilityThrowBaseball
extends Ability


var cooldown_count_down: float = 1
var packed_projectile: PackedScene = preload("res://Entities/Projectile.tscn")

func _ready():
	cooldown_count_down = $'Composition/Cooldown'.base_value
	ability = load("res://Resources/Data/Abilities/ThrowBaseball.tres")	

func on_ready():
	cooldown_count_down = $'Composition/Cooldown'.base_value
	return true
	
func on_active(_delta):
	var new_projectile = packed_projectile.instantiate()
	new_projectile.source_entity = player
	new_projectile.target_direction = player.position.direction_to(get_global_mouse_position()) 
	if player && player.global_projectile_container:
		if player.global_projectile_container.get_child_count() < 10:
			player.global_projectile_container.add_child(new_projectile)
			return true
	else:
		self.add_child(new_projectile)
		return true
	return false

func on_recovery(_delta):
	## No recovery phase
	return true

func on_cooldown(_delta):
	if cooldown_count_down > 0: 
		cooldown_count_down -= 1 * _delta
	else:
		return true
	return false
