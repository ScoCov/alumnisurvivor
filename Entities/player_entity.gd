class_name Player_Entity
extends Entity

#region Description
## This entity is the base entity used by the playable character. This is the soruce to be modified
## by the options selected by the player before going into the map. As a protection, the Global
## variables will be fed a default value so that this entity can always be populated with some data,
## no matter where it is used.
#endregion

signal loaded 
signal death

## Eventually remove this and place this into the Experience Manager
const XP_COLLECTION_RANGE_DEFAULT = 100 

@export_category("Student Components")
@export var student_manager: Student_Manager
@export var experience: Experience_Manager 
@export var abilities: Ability_Manager

@onready var pick_up_range = $Sensors/XP_Pickup_Range/CollisionShape2D

func _process(_delta):
	pick_up_range.shape.radius = XP_COLLECTION_RANGE_DEFAULT * (1 + items.get_attribute_bonus("collection_range"))
	
func _ready():
	loaded.emit()
	
func _render_student() -> void:
	if not student_manager.active_student: return
	$Visuals/Head/Hair.texture = student_manager.active_student.hair 
	$Visuals/Head/Eyebrows.texture = student_manager.active_student.eyebrows
	$Visuals/Head/Eyes.texture = student_manager.active_student.eyes
	$Visuals/Head/Mouth.texture = student_manager.active_student.mouth


## When an xp_node is within range of the of the pickup field, give the node
## a target of this entity.
func _on_xp_collector_body_entered(body):
	if body is XP_Node:
		body.target = self

## Once the xp_node reaches this area, it will be considered collected.
func _on_xp_collection_zone_body_entered(body):
	if body is XP_Node:
		body.collide_with_player()
		experience.add_experience(body.xp_value)

## I probably don't need this as I can attach this to the health_components death signal.
func _on_health_component_damage_lethal():
	death.emit()

## Whenever the player swaps between students in-game, we will change out the visual components.
## I will likely also want to attach some sort of visual effect as well. 
func _on_student_manager_student_swap():
	_render_student()
