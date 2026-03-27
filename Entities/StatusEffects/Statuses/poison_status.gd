class_name Status_Poison
extends Status_Effect_Entity

@export var damage: float = 1
@export var tick_count: int = 0
@export var pulse_rate: int = 1
@export var duration_time: float = 3:
	set(value):
		duration_time = value
		if duration:
			duration.wait_time = value
			
@export var tick_rate: float = 1

@onready var duration = $Duration
@onready var _tick = $Tick

func _ready():
	duration.wait_time = duration_time
	_tick.wait_time = tick_rate
	
func _process(delta):
	$Label.position = entity.position
	$Label.text = "Count: %s" % tick_count
	pulse_rate += 15 * delta
	entity.modulate = Color.GREEN
	entity.modulate.a = sin(pulse_rate)

func _on_expires():
	entity.modulate = Color(1,1,1,1)

func _on_tick():
	tick_count += 1
	entity.health.apply_dot_damage(damage)
	
func _on_initial_infection():
	entity.modulate = status_color
