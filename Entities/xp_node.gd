class_name XP_Node
extends CharacterBody2D

signal collected
signal dropped

@export var target: Student_Entity
@export var movement_speed: float = 100
@export var xp_value: float = 1.0
@export var debug_value_random_limit: float = 50


func _ready():
	xp_value = randi_range(1, debug_value_random_limit)
	var value = xp_value / debug_value_random_limit 
	scale = Vector2(scale.x + (scale.x * value), scale.y + (scale.y * value))
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
