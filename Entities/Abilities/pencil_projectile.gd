class_name Pencil_Projectile
extends CharacterBody2D

@export var target_location: Vector2
@export var angle: float = 0
@export var direction: Vector2 = Vector2.ZERO
@export var parent_ability: Ability_Entity
@export var parent_entity: Entity
@export var bounces_left: int = 0
@export var pierces_left: int = 0

@onready var collision_shape_2d = $Hitbox/CollisionShape2D
@onready var sprite_2d = $Sprite2D

func _ready():
	var _angle = position.direction_to(target_location).rotated(angle).angle()
	$Sprite2D.rotation = _angle
	$Hitbox.rotation = _angle
	
func _physics_process(_delta):
	_movement()
	move_and_slide()

func _movement(_target_location = target_location):
	if velocity == Vector2.ZERO or _target_location != target_location:
		var _direction = position.direction_to(_target_location).rotated(angle)
		velocity = (_direction) * (parent_ability.ability.projectile_speed )

func _on_duration_timeout():
	self.queue_free()

func _bounce_pierce() -> bool:
	if bounces_left > 0 or pierces_left > 0:
		if bounces_left > 0: ## Do Bounce First
			bounces_left -= 1
		elif pierces_left > 0: ## Do Pierce Second (or not at all if Bounce is done)
			pierces_left  -= 1
		return true
	return false

func _on_hitbox_body_entered(body):
	body.health.apply_damage_rider(Damage_Rider.new(parent_entity,parent_ability , parent_entity.items))
	var total_knockback = (parent_ability.ability.knockback + parent_entity.items.get_attribute_bonus("knockback"))
	if total_knockback != 0: 
		body.movement_component.knockback_effect(parent_entity.position.direction_to(body.position), 
														total_knockback)
	if _bounce_pierce():
		var new_target = Vector2(position.x + randf_range(-0.99,0.99) ,position.y + randf_range(-0.99,0.99) )
		var enemy_array: Array = body.get_parent().get_children().filter(func(child): return child != body)
		if len(enemy_array) > 0 and bounces_left > 0:
			new_target = enemy_array[randi_range(0, len(enemy_array)-1)].position
		_movement(new_target)
	else:
		self.queue_free()

func _on_hitbox_body_exited(_body):
	if bounces_left > 0 or pierces_left > 0:
		if bounces_left > 0:
			bounces_left -= 1
		elif pierces_left > 0:
			pierces_left  -= 1
