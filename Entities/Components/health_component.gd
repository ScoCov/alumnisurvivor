class_name Health_Component
extends Node

signal damage_taken
signal damage_negated
signal damage_healed

## Allows cheats to be applied.
@export_group("Debug Mode")
@export var debug: bool = false

@export_category("Health")
## This is the health the character will start with at the beginning of the game.
## Eventually, the player will have the option to increase this value.
@export var maximum_health: int = 10;

@export var current_health: int = 10:
	set(value):
		if invulnerable: pass
		current_health = value

## This will behave as 'extra' health. If an ability allows to heal past maximum
## it will be stored in shield, and then shield will be taken from before health 
## has anything removed. 

##NOTE - Idea: Should there be a mechanic that when the shield depletes the 
## remaining damage roll into normal health? I feel having it get destroyed 
## could add to imergent gameplay.
@export var shield: int = 0:
	set(value):
		if invulnerable: pass
		shield = value

## Percentage of how much health can be gained passed the maximum health. Default = 0.25 (25%)
@export var over_shield_maximum: float = 0.25
var shield_maximum_limit: int:
	set(value):
		pass
	get:
		return maximum_health * over_shield_maximum

## Armor will be applied to a logarithmic function, to provide a value. log(armor) * 100
@export var armor: int = 0;

@export_group("Invulnerability")
## When true, prevents all damage that would be dealt.
@export var invulnerable: bool = false
## Length of time the player is immune to any damage, after taking damage from an enemy. DEFAULT = 0.33
@export var invulnerability_time: float = 0.33:
	set(value):
		invulnerability_time = value
		if has_node("Invulnerability Timer"):
			$"Invulnerability Timer".wait_time = value

@onready var invulnerability_timer = $"Invulnerability Timer"

var active_state: State:
	set(value):
		pass
	get:
		if has_node("StateMachine"):
			return $StateMachine.initial_state
		return active_state


func _on_invulnerability_timer_timeout():
	invulnerable = false
