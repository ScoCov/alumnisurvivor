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
@export var sprite: Sprite2D

##Private Data
var _original_position: Vector2

func _ready():
	$'LifeTimer'.wait_time = $Composition/Duration.base_value
	$'LifeTimer'.connect("timeout", life_over)
	$'LifeTimer'.start()
	if source_entity and source_entity is StudentPlayer:
		$HitBox.body_entered.connect(hit_enemy)
		$HitBox.collision_mask = 2
		$HitBox.collision_layer = 2
	if source_entity and source_entity is EnemyEntity:
		$HitBox.body_entered.connect(hit_player) 
		$HitBox.collision_mask = 1
		$HitBox.collision_layer = 1

		

func _process(_delta):
	if velocity == Vector2(): ## If moving don't redirect or adjust velocity.
		position = source_entity.position if source_entity else Vector2()
		_original_position = position
		var direction = target_direction if target_direction else velocity.direction_to(get_global_mouse_position())
		$HeroDollTestSize.flip_h = true if direction.x < 0 else false
		velocity = (direction * $Composition/AttackSpeed.base_value)
	move_and_slide()
	if parent_ability:
		if position.distance_to(_original_position) > parent_ability.get_node("/Composition/Range").base_value:
			life_over()
	
func life_over():
	queue_free()
	
func hit_player(body: StudentPlayer):
	if pierce_count == 0 and bounce_count == 0:
		body.queue_free() # Deal Damage
		queue_free()
	elif pierce_count > 0:
		pierce_count -= 1
	elif bounce_count > 0:
		bounce_count -= 1
	
func hit_enemy(body: EnemyEntity):
	if pierce_count == 0 and bounce_count == 0:
		body.queue_free() # Deal Damage
		queue_free()
	elif pierce_count > 0:
		pierce_count -= 1
	elif bounce_count > 0:
		bounce_count -= 1
	
