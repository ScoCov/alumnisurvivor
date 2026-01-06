class_name Student_Entity
extends CharacterBody2D

#region Description
## This entity is the base entity used by the playable characters, the Students. Each student
## will inherit their class/scene from this entity. 
##
## Everything that is inside this file, StudentEntity.tscn, will be applied to all other students. If
## changes are made on this, that change will be applied to all other Student Entities that inherit 
## this class. The only exceptions will be when the Student overrides a default value, those 
## will not rever to default values when this file is changes (and saved). 
#endregion

const DEFAULT_MOVEMENT_SPEED: float = 150
@export_group("Tools")
## Check box to have StudentEntity be in debug mode.
@export var debug: bool = false
@export var is_controllable: bool = true
@export_category("Entity Data")
@export var student: StudentResource 
var movement_component: Movement_Component
var health: Health_Component
@onready var status_effects = $StatusEffects
var _taking_damage_particles:= preload("res://Entities/Effects/taking_damage.tscn")
var _healing_damage_particles:= preload("res://Entities/Effects/healing_damage.tscn")

var angle = 0

func _input(event):
	if not is_controllable: pass
	if event.is_action_pressed("dash", false):
		movement_component.is_dash = true
	
func _ready():
	movement_component = $Stats/MovementComponent
	health = $Stats/HealthComponent
	health.damage_taken.connect(emit_damage_indicator.bind("damage"))
	health.damage_healed.connect(emit_damage_indicator.bind("healed"))
	_render_student()
		
func emit_damage_indicator(param: String):
	var new_particle
	match param:
		"damage":
			new_particle = _taking_damage_particles.instantiate()
		"healed":
			new_particle = _healing_damage_particles.instantiate()
	self.add_child(new_particle)
	
func _process(_delta):
	if not is_controllable: pass
	movement_component = $Stats/MovementComponent if not movement_component else movement_component
	health = $Stats/HealthComponent if not health else health

func _render_student() -> void:
	if not student: return
	if student.hair != null:
		$Visuals/Head/Hair.texture = student.hair
	else:
		$Visuals/Head/Hair.texture = null
	$Visuals/Head/Eyebrows.texture = student.eyebrows
	$Visuals/Head/Eyes.texture = student.eyes
	$Visuals/Head/Mouth.texture = student.mouth

func student_update(_student: StudentResource) -> void:
	student = _student
	_render_student()
	
