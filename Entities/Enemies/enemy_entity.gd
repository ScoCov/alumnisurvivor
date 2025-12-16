class_name Enemy_Entity
extends CharacterBody2D

@export var enemy: EnemyResource
@export var player: Student_Entity
@export var movement_strategy: EnemyMovementStrategy.type
@onready var movement_component: Enemy_Movement_Component = $EnemeyMovementComponent
@onready var health: Health_Component = $HealthComponent
@onready var _original_position_debug:= position
var _taking_damage_particles:= preload("res://Entities/Effects/taking_damage.tscn")
var _healing_damage_particles:= preload("res://Entities/Effects/healing_damage.tscn")

func _ready():
	movement_component.movement_strategy = movement_strategy
	health.damage_taken.connect(emit_damage_indicator.bind("damage"))
	health.damage_healed.connect(emit_damage_indicator.bind("healed"))
	
func _process(_delta):
	if health.active_state is DeadState:
		health.find_child("Statemachine").current_state = health.find_child("Full Health")
		health.current_health = health.maximum_health
		position = _original_position_debug
		velocity *= 0
	$Label.text = "%s/%s" % [health.current_health, health.maximum_health]
	
func emit_damage_indicator(param: String):
	var new_particle
	match param:
		"damage":
			new_particle = _taking_damage_particles.instantiate()
		"healed":
			new_particle = _healing_damage_particles.instantiate()
	self.add_child(new_particle)
	
	
func build_enemy():
	health.maximum_health = enemy.maximum_health
	movement_component.movement_speed = enemy.movement_speed
