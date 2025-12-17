class_name Status_Slow
extends Status_Effect_Entity

var speed_modification: float
var alpha_value: float = 0.25
var _signed: int = 1.0
@export var pulse_rate: float = 1
@export var min_transparency: float = 0.25
@export var max_transparency: float = 1.0
@export var status_color:= Color(0.25, 0.55,0.25,1)

func _init():
	name = "SlowStatus"
	
func _ready():
	if not entity: self.queue_free()
	entity.movement_component.speed_modifier -= speed_modification

func _process(_delta):
	alpha_value += _signed * (pulse_rate * _delta)
	if alpha_value <= min_transparency or alpha_value >= max_transparency:
		_signed *= -1
	var color:= Color(alpha_value,alpha_value,alpha_value,1)
	entity.modulate = color

func _on_duration_timeout():
	entity.modulate = Color(1,1,1,1) #Restore to normal - Will likely replace with effect
	entity.movement_component.speed_modifier += speed_modification
	self.queue_free()

func _on_tick_timeout():
	pass # Replace with function body.
