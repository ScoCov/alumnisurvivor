class_name Player_Entity
extends Entity

signal loaded 
signal death
signal swapped_students

const XP_COLLECTION_RANGE_DEFAULT = 100

enum _student_in_control {Student, Besty} 

#region Description
## This entity is the base entity used by the playable characters, the Students. Each student
## will inherit their class/scene from this entity. 
##
## Everything that is inside this file, StudentEntity.tscn, will be applied to all other students. If
## changes are made on this, that change will be applied to all other Student Entities that inherit 
## this class. The only exceptions will be when the Student overrides a default value, those 
## will not rever to default values when this file is changes (and saved). 
#endregion

## Check box to have StudentEntity be in debug mode.
@export var is_controllable: bool = true
@export var current_student: _student_in_control = _student_in_control.Student

@export_category("Student Components")
@export var student_manager: Student_Manager
@export var experience: Experience_Manager 
@export var abilities: Ability_Manager

@onready var pick_up_range = $Sensors/XP_Pickup_Range/CollisionShape2D

var student: StudentResource:
	set(value):
		pass
	get():
		return Global.SELECTED_STUDENT if current_student == _student_in_control.Student else Global.SELECTED_BESTY
		
var vfx: Node2D:
	get():
		return $VFX

func _input(event):
	if event.is_action_pressed("swap_besty"):
		## Create Swap Mechanics here
		swapped_students.emit()
	
func _process(_delta):
	pick_up_range.shape.radius = XP_COLLECTION_RANGE_DEFAULT * (1 + items.get_attribute_bonus("collection_range"))
	
func _ready():
	loaded.emit()
	
func _render_student() -> void:
	if not student: return
	$Visuals/Head/Hair.texture = student.hair if student.hair != null else null
	$Visuals/Head/Eyebrows.texture = student.eyebrows
	$Visuals/Head/Eyes.texture = student.eyes
	$Visuals/Head/Mouth.texture = student.mouth

func student_update(_student: StudentResource) -> void:
	_render_student()
	
func _on_xp_collector_body_entered(body):
	if body is XP_Node:
		body.target = self

func _on_xp_collection_zone_body_entered(body):
	if body is XP_Node:
		body.collide_with_player()
		experience.add_experience(body.xp_value)

func _on_health_component_damage_lethal():
	death.emit()

func _on_student_manager_student_swap():
	$Visuals/Head/Hair.texture = student_manager.active_student.hair 
	$Visuals/Head/Eyebrows.texture = student_manager.active_student.eyebrows
	$Visuals/Head/Eyes.texture = student_manager.active_student.eyes
	$Visuals/Head/Mouth.texture = student_manager.active_student.mouth
