class_name Enemy_Wander_Movement_State
extends State

@export var enemy_movement_component: Enemy_Movement_Component

## The target the entity will be going towards.
@onready var entity: Enemy_Entity = enemy_movement_component.enemy_entity


func update(_delta: float):
	pass
