class_name Enemy_Entity
extends CharacterBody2D

signal death

@export var entity: EnemyResource
@export var player: Student_Entity
@onready var sprite_2d = $Sprite2D
@onready var movement_component: Enemy_Movement_Component = $EnemeyMovementComponent
@onready var health: Health_Component = $HealthComponent
@onready var status_effects: Node2D = $StatusEffects

const _taking_damage_particles:= preload("res://Entities/Effects/taking_damage.tscn")
const _healing_damage_particles:= preload("res://Entities/Effects/healing_damage.tscn")

func _ready():
	build_enemy()
	health.damage_taken.connect(emit_damage_indicator.bind("damage"))
	health.damage_healed.connect(emit_damage_indicator.bind("healed"))
	
func _process(_delta):
	if health.active_state is DeadState:
		death.emit()
		self.queue_free()
	
func emit_damage_indicator(param: String):
	var new_particle
	match param:
		"damage":
			new_particle = _taking_damage_particles.instantiate()
		"healed":
			new_particle = _healing_damage_particles.instantiate()
	self.add_child(new_particle)
	
func build_enemy():
	assert(entity, "Must have an Enemy resource to build enemy entity")
	health.maximum_health = entity.maximum_health
	movement_component.movement_speed = entity.movement_speed
	$Sprite2D.texture = entity.image_variants[2] ## get the 256x256 images
