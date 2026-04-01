class_name Ability_Manager
extends Node2D

## The Ability manager is to be used on any entity that will have an action. This 
## will include actions like "Touch Damage" for the sake of consistency of 
## implementing damage.

signal ability_added
signal ability_removed

@export var max_abilities: int = 4
## Needed for debugging purposes
@export var starting_ability: Ability_Resource
@export var parent_entity: Entity

var abilities: Dictionary = {}

func _ready():
	if parent_entity is Player_Entity and parent_entity.is_controllable:
		var ability: PackedScene = load("res://Entities/Abilities/%s.tscn" % Global.SELECTED_STUDENT.starting_ability.id)
		var ability_entity: Ability_Entity = ability.instantiate()
		ability_entity.entity = get_parent()
		starting_ability = Global.STUDENT_ROSTER[0].starting_ability
		_add_ability(starting_ability, ability_entity)
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
