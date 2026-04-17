class_name Status_Effect_Entity
extends Node2D

## This signal will be executed any time the duration of the status effect is up and
## either there is no repeat command, or the stack_count is 0.
signal expires
signal stack_reduced
signal stack_increase
signal initial_infection
signal tick

@export var status_resource: Status_Effect_Resource
## Supply a color to tint the enity when they have the status effect on them.
@export var entity: Entity
@export var parent_ability: Ability_Entity
@export var stack_count: int = 1:
	set(value):
		if max_stack > 0:
			stack_count = clamp(value, 0, max_stack)
		else:
			stack_count = value
## If set to -1 the stack can be effectively infinite.
@export var max_stack: int = -1
## Data for the status_effect
@export var status_color: Color
##This will always be added programmically
@export var attribute_effected: AttributeResource

func _ready():
	assert(status_resource, "Status-Effects must be paired with Status_Effect_Resource")
	assert(entity, "Status-Effects must be assigned an entity.")
	$Tick.wait_time = status_resource.tick_rate 
	$Duration.wait_time = status_resource.duration * (1 + entity.items.get_attribute_bonus("duration"))
	initial_infection.emit()
	
func _on_duration_timeout():
	stack_count -= 1
	if stack_count <= 0:
		expires.emit()
		self.queue_free()
	stack_reduced.emit()

func _on_tick_timeout():
	tick.emit()

func update_tick(new_tick: float):
	$Tick.wait_time = new_tick
	if !$Tick.is_stopped():
		$Tick.stop()
	$Tick.start(0)
	
func update_duration(new_duration: float):
	$Duration.wait_time = new_duration
	if !$Duration.is_stopped():
		$Duration.stop()
	$Duration.start(0)

func increase_stack():
	if !$Duration.is_stopped():
		$Duration.stop()
	$Duration.start(0)
	stack_increase.emit()
