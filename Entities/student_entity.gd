@tool
class_name Student_Entity
extends Entity

signal loaded 
signal death
signal swapped_students

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
@export var student: StudentResource = Global.SELECTED_STUDENT:
	set(_student):
		student = _student
		student_update(_student)
@export var besty: StudentResource = Global.SELECTED_BESTY
@export var starting_ability: Ability_Resource

@onready var experience: Experience_Manager = $Experience
@onready var movement_component: Movement_Component = $MovementComponent
@onready var items: Item_Container = $Items
@onready var abilities: Ability_Manager = $Abilities
@onready var dashes: Dash_Manager = $Dashes
var vfx: Node2D:
	get():
		return $VFX

func _input(event):
	if event.is_action_pressed("swap_besty"):
		var temp = student
		student = besty
		besty = temp
		swapped_students.emit()
		
func _get_configuration_warnings():
	var msg: Array[String]
	var children = get_children()
	if not children.any(func(child): return child is Experience_Manager):
		msg.append("Student Entity requires an Experience Manager Node.")
	return msg
	
func _ready():
	get_universal_components()
	abilities.starting_ability = starting_ability
	dashes.visible = is_controllable
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
