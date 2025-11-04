class_name StudentEntity
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
@export var is_controllable: bool = true:
	set(value):
		is_controllable = value
		if not is_controllable: 
			$Stats.queue_free()
@export_category("Entity Data")
@export var student: StudentResource 
var movement: Movement_Component
var health: Health_Component

func _input_event(viewport, event, shape_idx):
	if not is_controllable: pass
	if event.is_action("dash"):
		movement.is_dash = true

func _ready():
	if is_controllable:
		movement = $Stats/MovementComponent
		health = $Stats/HealthComponent
	_render_student()
		
func _process(_delta):
	if not is_controllable: pass

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
