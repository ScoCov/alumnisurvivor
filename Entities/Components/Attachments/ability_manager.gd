class_name Ability_Manager
extends Node2D

## The Ability manager is to be used on any entity that will have an action. This 
## will include actions like "Touch Damage" for the sake of consistency of 
## implementing damage.

signal ability_added
signal ability_removed

#TEST
var baseball_bat_resource = load("res://Resources/Data/Abilities/baseball_bat.tres") 
#


@export var max_abilities: int = 4
## Needed for debugging purposes
@export var starting_ability: Ability_Resource
@export var parent_entity: Entity

var abilities: Dictionary = {}

func _ready():
	#parent_entity = get_parent() as Student_Entity if get_parent() is Student_Entity else Enemy_Entity
	if parent_entity is Student_Entity and parent_entity.is_controllable:
		#if not (parent_entity as Student_Entity).is_controllable: return
		#starting_ability = get_parent().starting_ability
		var ability: PackedScene = load("res://Entities/Abilities/%s.tscn" % Global.SELECTED_STUDENT.starting_ability.id)
		var ability_entity: Ability_Entity = ability.instantiate()
		ability_entity.entity = get_parent()
		#ability_entity.entity = get_parent() if get_parent() is Entity else null
		_add_ability(starting_ability if starting_ability else baseball_bat_resource, ability_entity)
		add_child(ability_entity)

func _on_child_entered_tree(node):
	assert(node is Ability_Entity, "Child must be Ability Entity")
	node.entity = get_parent()
	_add_ability(node.ability, node)
	ability_added.emit()

func _on_child_exiting_tree(node):
	abilities.erase((node as Ability_Entity).ability.id)
	ability_removed.emit()

func _add_ability(ability: Ability_Resource, entity: Ability_Entity):
	abilities.get_or_add(ability.id, entity)
