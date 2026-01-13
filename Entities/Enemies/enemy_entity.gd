class_name Enemy_Entity
extends Entity

signal death

@export var entity: EnemyResource
@export var player: Student_Entity
@onready var sprite_2d = $Sprite2D
@onready var movement_component: Enemy_Movement_Component = $EnemeyMovementComponent

const _xp_node:= preload("res://Entities/xp_node.tscn")

func _ready():
	get_universal_components()
	build_enemy()
	
func _process(_delta):
	if health.active_state is DeadState:
		death.emit()
		drop_xp()
		self.queue_free()

func build_enemy():
	assert(entity, "Must have an Enemy resource to build enemy entity")
	health.maximum_health = entity.maximum_health
	movement_component.movement_speed = entity.movement_speed
	$Sprite2D.texture = entity.image_variants[2] ## get the 256x256 images

func drop_xp():
	var new_node = _xp_node.instantiate()
	new_node.position = position
	new_node.xp_value = entity.xp_per_power * entity.power_level
	get_parent().add_child(new_node)
