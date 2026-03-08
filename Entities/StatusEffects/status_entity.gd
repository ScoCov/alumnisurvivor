class_name Status_Effect_Entity
extends Node2D

## This signal will be executed any time the duration of the status effect is up and
## either there is no repeat command, or the stack_count is 0.
signal expires
signal stack_reduced
signal initial_infection
signal tick

@export var status_resource: Status_Effect_Resource
## Supply a color to tint the enity when they have the status effect on them.
@export var entity: Entity
## Use this to help the algorithims of the statuses.
## Either Student_Entity or Enemy_Entity
@export var stack_count: int = 1
## If set to -1 the stack can be effectively infinite.
@export var max_stack: int = -1
## Data for the status_effect
@export var status_color:= Color(0.25, 0.55,0.25,1)
##This will always be added programmically
@export var attribute_effected: AttributeResource


func _ready():
	assert(status_resource, "Status-Effects must be paired with Status_Effect_Resource")
	assert(entity, "Status-Effects must be assigned an entity.")
	update_tick(status_resource.duration)
	update_duration(status_resource.tick_rate)
	initial_infection.emit()
	
func _on_duration_timeout():
	if stack_count < 1:
		expires.emit()
		self.queue_free()
	stack_count -= 1
	stack_reduced.emit()

func _on_tick_timeout():
	tick.emit()

func update_tick(new_tick: float):
	$Tick.wait_time = new_tick
	
func update_duration(new_duration: float):
	$Duration.wait_time = new_duration
