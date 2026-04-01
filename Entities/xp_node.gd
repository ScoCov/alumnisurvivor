class_name XP_Node
extends CharacterBody2D

signal collected
signal dropped

@export var target: Player_Entity
@export var movement_speed: float = 100
@export var xp_value: float = 1.0
@export var debug_value_random_limit: float = 50

func _ready():
	scale = Vector2(scale.x + (scale.x * clamp(xp_value/10,0,0.5)), 
					scale.y + (scale.y * clamp(xp_value/10,0,0.5)))
	dropped.emit()

func _process(_delta):
	if target:
		if not $AnimationPlayer.is_playing():
			$AnimationPlayer.play("spin")
		velocity = position.direction_to(target.position) * movement_speed
		move_and_slide()

func collide_with_player():
	collected.emit()
	self.queue_free()
