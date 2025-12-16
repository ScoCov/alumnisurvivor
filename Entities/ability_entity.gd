class_name Ability_Entity
extends Node2D


#region Development Notes
## This is the base ability entity that will have all the other abilities based upon.
## each form should be an instantiated Ability_Entity.
#endregion

@export var player: Student_Entity
@export var ability: Ability_Resource

## Assign Nodes and reusable default values.
@onready var detection_range = $DetectionRange

## This stuff
var entities_in_range: Array[Enemy_Entity]

## Counters
var attack_speed_current: float = 0.0
var cooldown_current: float = 0.0
var projectiles_current: int = 0
var knockback: float = 0

func _ready():
	pass
	
func _physics_process(_delta):
	pass
	
## Returnting true to these state functions will trigger it to transition
func on_ready() -> bool:
	return true
	
func on_active() -> bool:
	return true
	
func on_recovery() -> bool:
	return true
	
func on_cooldown() -> bool:
	return true
	
func _on_detection_range_body_entered(body):
	pass

func _on_detection_range_body_exited(body):
	pass
	
func _on_hitbox_body_entered(body):
	pass

##NOTE:
## Unnecessary; keeping for reference. At least, until I remember where this 
## code would actually be useful. I suspect it'll be useful in the Item_Management
## system.
func ability_factory():
	assert(ability, "Ability_Entity does not have the Ability_Resource associated with it.")
	for prop in ability.get_property_list():
		if self.get(prop.name): 
			## If the ability has the properties that the resource has, take
			## the resource values and assign them to the ability_entity.
			self.set(prop.name, prop)
