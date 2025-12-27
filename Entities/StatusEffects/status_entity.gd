class_name Status_Effect_Entity
extends Node2D

##This will always be added programmically
@export var attribute_effected: AttributeResource
## Either Student_Entity or Enemy_Entity
@export var entity: CharacterBody2D
## Use this to help the algorithims of the statuses.
@export var stack_count: int = 0
## If set to -1 the stack can be effectively infinite.
@export var max_stack: int = -1
## Data for the status_effect
@export var status_resource: Status_Effect_Resource


## Toggles whether or not the status effect will continue or stop after 
## executing the timeout.
var repeat: bool = true:
	set(value):
		$Duration.one_shot = value
		repeat = value

func _ready():
	pass

## This will refresh the status effect
func refresh():
	$Duration.stop()
	$Duration.start()

func _on_duration_timeout():
	pass # Replace with function body.

func _on_tick_timeout():
	pass # Replace with function body.
