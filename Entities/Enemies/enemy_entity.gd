class_name Enemy_Entity
extends Entity

signal death

const _XP_NODE:= preload("res://Entities/xp_node.tscn")

@export var entity: EnemyResource

@onready var sprite_2d = $Sprite2D
@onready var movement_component: Enemy_Movement_Component = $EnemeyMovementComponent

var player: Student_Entity
#
func _process(_delta):
	var string_to_add: String = ""
	if movement_component.check_for_slow:
		var slow_entity = status_effects.get_status_effect(load("res://Resources/Data/StatusEffects/slow_status.tres"))
		if slow_entity:
			string_to_add = "%s (%s)  = %s" % [slow_entity.stack_count, slow_entity.status_resource.base_value, slow_entity.stack_count * slow_entity.status_resource.base_value]
	$Label.text = "speed: %s | %s" % [movement_component.speed, string_to_add, ] 
	
func _ready():
	get_universal_components()
	health.damage_lethal.connect(_death)
	build_enemy()

func build_enemy():
	assert(entity, "Must have an Enemy resource to build enemy entity")
	movement_component.movement_speed = entity.movement_speed
	$Sprite2D.texture = entity.image_variants[2] ## get the 256x256 images

func drop_xp():
	var new_node = _XP_NODE.instantiate()
	new_node.position = position
	new_node.xp_value = entity.xp_per_power * entity.power_level
	get_parent().add_child(new_node)
	
func _death():
	self.death.emit()
	call_deferred("drop_xp")
	self.queue_free()

func free_queue():
	self.queue_free()
