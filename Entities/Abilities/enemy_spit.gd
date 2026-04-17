class_name Ability_Enemy_Spit
extends Ability_Entity

const projectile: PackedScene = preload("res://Entities/projectile.tscn")

@export_color_no_alpha var projectile_color
@export_range(10,1000,1) var attack_range: float = 120
@export_range(10,1000,1) var radius: float = 64
@export_range(10, 200, 1) var speed: float = 85
@export_range(0.2, 10, 0.1) var firerate: float = 2.0
@export var texture: Texture

func _ready():
	detection.shape.radius = radius
	
func on_ready():
	_cooldown_complete = false
	var origin 
	var range_total = attack_range
	if not entity and debug:
		origin = get_global_mouse_position() 
		return true
	if target_entity:
		origin = target_entity.position
		range_total = ability.attack_range + item_bonus("attack_range")
		return origin.distance_to(target_entity.position) < range_total
	return false
	
func on_active():
	var new_proj = projectile.instantiate()
	new_proj.parent_ability = self
	new_proj.position = global_position
	new_proj.texture = texture
	if not target_entity and debug:
		new_proj.target = Vector2.ZERO
		new_proj.direction = global_position.direction_to(Vector2.ZERO)
	else:
		new_proj.parent_entity = entity
		new_proj.target = target_entity.global_position
		new_proj.direction = global_position.direction_to(target_entity.position)
	get_tree().root.add_child(new_proj)
	return true
	
func on_recovery():
	return true
	
func on_cooldown():
	if cooldown.is_stopped() and not _cooldown_complete:
		cooldown.start()
	return _cooldown_complete

func _on_cooldown_timeout():
	_cooldown_complete =  true


func _on_detection_body_entered(body):
	target_entity = body


func _on_detection_body_exited(body):
	pass # Replace with function body.
