class_name Status_Burn
extends Status_Effect_Entity

var alpha_value: float = 0.25
var _signed: int = 1.0
@export var pulse_rate: float = 1
@export var min_transparency: float = 0.25
@export var max_transparency: float = 1.0
@export var status_color:= Color(0.25, 0.55,0.25,1)

func _init():
	name = "BurnStatus"

func _process(_delta):
	alpha_value += _signed * (pulse_rate * _delta)
	if alpha_value <= min_transparency or alpha_value >= max_transparency:
		_signed *= -1
	var color:= status_resource.effect_color
	color.a = alpha_value
	entity.modulate = color

func _on_duration_timeout():
	entity.modulate = Color(1,1,1,1)
	self.queue_free()

func _on_tick_timeout():
	entity.health.attempt_damage(self, -status_resource.base_value)
