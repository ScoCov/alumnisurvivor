class_name Projectile
extends CharacterBody2D


@export_category("Meta Data")
## Intended to be either the StudentPlayer Entity or an EnemyEntity
@export var source_entity: Node2D
## Intended to be the ability of a Player, or a basic Enemy_Attack Class (TO BE MADE)
@export var parent_ability: Ability
@export_group("Targets")
#@export var target_position: Vector2 #NOTE: May need in future
## Direction to the target. If left null, this will target the Global Mouse Position.
@export var target_direction: Vector2

@export_group("Combat Data")
## When 0 the projectile will destroy itself upon contact with target.
@export var pierce_count: int = 0
## When 0 the projectile will destroy itself upon contact with the target.
@export var bounce_count: int = 0
## TODO: I want to make damage package a class/strategy that can be built up and then delivered
## to contain various information - a flat damage value, the source of the damage, it's crit chance,
## or anything else I can associate with a damage dealing event. NOTE:This is likely where I can also
## do statistical data for the user.
@export var damage_package: float

@export_category("Images")

@onready var sprite: Sprite2D = $HeroDollTestSize

##Private Data
var _original_position: Vector2

func _ready():
	sprite.texture = parent_ability.ability.menu_image
	if parent_ability and parent_ability is Ability:
		$Composition/AttackSpeed.base_value = parent_ability.get_node("Composition/AttackSpeed").value
		$Composition/Range.base_value = parent_ability.get_node("Composition/Range").value
		$Composition/Damage.base_value = parent_ability.get_node("Composition/Damage").value
	if source_entity and source_entity is StudentEntity:
		$HitBox.body_entered.connect(hit_enemy)
		$HitBox.collision_mask = 2
		$HitBox.collision_layer = 2
		pierce_count = $Composition/Pierce.value + source_entity.get_node("Composition/Pierce").value
	if source_entity and source_entity is EnemyEntity:
		$HitBox.body_entered.connect(hit_player) 
		$HitBox.collision_mask = 1
		$HitBox.collision_layer = 1

		

func _process(_delta):
	if velocity == Vector2(): ## If moving don't redirect or adjust velocity.
		_original_position = position
		var direction = target_direction if target_direction else velocity.direction_to(get_global_mouse_position())
		$HeroDollTestSize.flip_h = true if direction.x < 0 else false
		velocity = (direction * $Composition/AttackSpeed.value) 
	move_and_slide()
	if parent_ability:
		if position.distance_to(_original_position) > get_node("Composition/Range").value:
			life_over()
	
func life_over():
	queue_free()
	
func hit_player(body: StudentEntity):
	if pierce_count == 0 and bounce_count == 0:
		life_over()
	elif pierce_count > 0:
		pierce_count -= 1
	elif bounce_count > 0:
		bounce_count -= 1
		
	body.emit_signal("take_damage", self)
	
func hit_enemy(body: EnemyEntity):
	if pierce_count == 0 and bounce_count == 0:
		life_over()
	elif pierce_count > 0:
		pierce_count -= 1
	elif bounce_count > 0:
		bounce_count -= 1
		var closest_vector2 := Vector2()
		var _target := get_global_mouse_position()
		var enemySpawner: Node = get_parent()
		for enemy in enemySpawner.get_children():
			if closest_vector2 == Vector2(0,0):
				_target = enemy.position
			else:
				if (enemy.position.distance_to(position) < enemy.position.distance_to(closest_vector2)):
					closest_vector2 = enemy.position
			if enemy.get_index() >= 5: # To prevent runaway calculations, limiting the check to 5 enemies.
				break
		velocity = body.position.direction_to(_target) * $Composition/AttackSpeed.value
		
	body.emit_signal("take_damage", $Composition/Damage.value, self)
