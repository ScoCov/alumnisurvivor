class_name Projectile
extends CharacterBody2D

@export var source_entity: Node2D
@export var parent_ability: Ability
@export var target_position: Vector2
@export var target_direction: Vector2
@export var pierce_count: int = 0
@export var bounce_count: int = 0
@export var tags: Array[Global.tag]
@export var sprite: Sprite2D


var _direction:= Vector2()

func _ready():
	$'LifeTimer'.wait_time = $Composition/Duration.base_value
	$'LifeTimer'.connect("timeout", life_over)
	$'LifeTimer'.start()

func _process(_delta):
	if velocity == Vector2():
		position = source_entity.position if source_entity else Vector2()
		_direction = velocity.direction_to(get_global_mouse_position())
		if target_direction:
			_direction = target_direction
		if _direction.x < 0:
			$HeroDollTestSize.flip_h = true	
		velocity = (_direction * $Composition/AttackSpeed.base_value)
	if $SpeedIndicator:
		$SpeedIndicator.text = ""
	move_and_slide()
	
func life_over():
	queue_free()
