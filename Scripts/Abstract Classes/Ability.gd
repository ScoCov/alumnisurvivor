class_name Ability
extends Node2D

## Abstract Class
@export var ability_name: String
@export var player_student: StudentPlayer
var action: Callable

## Caled Every tick
func on_update():
	pass

## Called when the ability is active phase
func on_active():
	pass
	
## Called when the ability is in recovery phase
func on_recover():
	pass
	
## Called when the ability is ready to be triggered again
func on_ready():
	pass
	
func on_cooldown():
	pass
	
## Called when the ability is upgraded
func on_upgrade():
	pass

