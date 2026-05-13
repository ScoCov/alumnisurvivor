class_name Enemy_Entity
extends Entity

signal death
signal birth

@export var entity: EnemyResource
@onready var sprite_2d = $Sprite2D
@export var shape: CollisionShape2D

func _ready():
	health.damage_lethal.connect(_death)
	build_enemy()
	birth.emit()

func build_enemy():
	assert(entity, "Must have an Enemy resource to build enemy entity")
	$Sprite2D.texture = entity.image_variants[2] ## get the 256x256 images

func get_damage_rider():
	return Damage_Rider.new(self, null, items)

func _death():
	death.emit()

func _on_health_component_knockback():
	var kb_value = 0
	(movment_component as Enemy_Movement_Component).knockback_effect(kb_value)
