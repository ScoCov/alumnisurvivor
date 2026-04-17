class_name Enemy_Movement_Component
extends Movement_Component

signal loaded

@export var movement_type: Strategy_Enemy_Movement

func _ready():
	movement_speed = entity.entity.movement_speed
	loaded.emit()
	
func _physics_process(delta):
	movement_type.update(entity,delta)
	if is_knocked_backed:
		entity.velocity = -entity.position.direction_to(entity.player.position) * (knockback_speed)
	if check_for_stun:
		entity.velocity *= 0
	entity.move_and_slide()
