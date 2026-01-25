@tool
class_name Ability_Manager
extends Node2D

## Ability Manager requires Ability_Entity as children.

signal ability_added
signal ability_removed

@export var max_abilities: int = 4
@export var starting_ability: Ability_Resource

var manual_target: Vector2
var abilities: Dictionary = {}

func _ready():
	var parent = get_parent() if get_parent() is Entity else null
	if parent is Student_Entity and not starting_ability :
		if not (parent as Student_Entity).is_controllable: return
		starting_ability = parent.starting_ability
		var ability: PackedScene = load("res://Entities/Abilities/%s.tscn" % starting_ability.id)
		var ability_entity: Ability_Entity = ability.instantiate()
		ability_entity.entity = get_parent() if get_parent() is Entity else null
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
