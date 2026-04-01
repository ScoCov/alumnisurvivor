class_name Enemy_Movement_Component
extends Movement_Component

@export var movement_type: Strategy_Enemy_Movement

func _ready():
	movement_speed = entity.entity.movement_speed
	
func _physics_process(delta):
	movement_type.update(entity,delta)
	if is_knocked_backed:
		entity.velocity = -entity.position.direction_to(entity.player.position) * (knockback_speed)
	entity.move_and_slide()

func _on_knockback_timer_timeout():
	is_knocked_backed = false

func knockback_effect(direction: Vector2, knockback_value: float):
	is_knocked_backed = true
	knockback_speed += knockback_value
