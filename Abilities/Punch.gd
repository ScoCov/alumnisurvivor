extends Ability
class_name AbilityPunch

@onready var fist: Node2D = $'Marker2D/Node2D'
@onready var hitbox: CollisionShape2D = $'Marker2D/Node2D/HitBox/CollisionShape2D'
@onready var stats: Node = $'Stats'
var target: EnemyEntity
	
	
func _process(_delta):
	if target:
		$'Marker2D'.look_at(target.position)
	else:
		$'Marker2D'.look_at(get_global_mouse_position())
		
func on_active():
	## TODO: Extract this code and place inside a Stragey. That Stragey Class will
	## consist of this code and will have the same methods as this has.
	if hitbox.disabled:
		hitbox.disabled = false
	var bonus_range: float = 0.0
	if player_student.item_list.attributes.has("ATTRIBUTE_RANGE"):
		bonus_range = player_student.item_list.attributes["ATTRIBUTE_RANGE"]
	if fist.position.x > stats.attributes["ATTRIBUTE_RANGE"].value + bonus_range:
		return true
	var bonus_value: float = 1
	if player_student.item_list.attributes.has("ATTRIBUTE_ATTACK_SPEED"):
		bonus_value = player_student.item_list.attributes["ATTRIBUTE_ATTACK_SPEED"]
	fist.position.x += stats.attributes["ATTRIBUTE_ATTACK_SPEED"].value * bonus_value
	return false
	 
func on_recover():
	hitbox.disabled = true
	if fist.position.x <= 0:
		return true
	var bonus_value: float = 1
	if player_student.item_list.attributes.has("ATTRIBUTE_ATTACK_SPEED"):
		bonus_value = player_student.item_list.attributes["ATTRIBUTE_ATTACK_SPEED"]
	fist.position.x -= stats.attributes["ATTRIBUTE_ATTACK_SPEED"].value * bonus_value
	return false
	
func on_cooldown():
	pass

func on_ready():
	hitbox.disabled = true
	pass
	
func on_upgrade():
	pass


func _on_hit_box_body_entered(body):
	if body is EnemyEntity:
		var base_damage: float = stats.attributes["ATTRIBUTE_DAMAGE"].value
		var bonus_damage: float = 1
		if player_student.item_list.attributes.has("ATTRIBUTE_DAMAGE"):
			bonus_damage = player_student.item_list.attributes["ATTRIBUTE_DAMAGE"]
		var total_damage: float = base_damage * bonus_damage
		body.stats.attributes["ATTRIBUTE_HEALTH"].take_damage(total_damage)
