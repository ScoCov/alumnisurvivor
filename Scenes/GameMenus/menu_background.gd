class_name Menu_Background
extends Control


@export_range(0.5,1,0.05) var mod_max_color: float = 0.5
@export_range(0.15,0.5,0.05) var mod_min_color: float = 0.15
@export_range(0,1,0.01) var mod_step_rate: float= 0.05

@onready var color_rect = $ColorRect
@onready var bg_layer = $bg_layer
var trans_color: bool = true
## Base Color
var r = mod_max_color
var g = mod_max_color
var b = mod_max_color
## Signed (Direction)
var rS = 1
var gS = 1
var bS = 1
## Randomized Increment (for bg_layer)
var rR
var gR
var bR
## Randomized Offset (for Color Rect)
var rO
var gO
var bO


func _process(delta):
	$Label.text = "Modulate: (%s,%s,%s,%s)\n
	R,G,B: (%s,%s,%s)\n
	rR,gR,bR: (%s,%s,%s)\n
	rO,gO,bO: (%s,%s,%s)" % [
		bg_layer.modulate.r, 
		bg_layer.modulate.g, 
		bg_layer.modulate.b, 
		bg_layer.modulate.a, 
		r,g,b,
		rR,gR,bR,
		rO,gO,bO]
	r += ((mod_step_rate + rR) * rS) * delta
	g += ((mod_step_rate + gR) * gS) * delta
	b += ((mod_step_rate + bR) * bS) * delta
	if r >= mod_max_color:
		rS = -1
	if rS == -1 and r <= mod_min_color:
		rS = 1
	if g >= mod_max_color :
		gS = -1
	if gS == -1 and g <= mod_min_color:
		gS = 1
	if b >= mod_max_color:
		bS = -1
	if bS == -1 and b <= mod_min_color:
		bS = 1
	bg_layer.modulate = Color(r,g,b)
	color_rect.modulate = Color(r+rO,g+gO,b+bO)
	pass

func _ready():
	$AnimationPlayer.play("Background_Movement")
	rR = randf_range(0,0.05)
	gR = randf_range(0,0.05)
	bR = randf_range(0,0.05)
	rO = randf_range(-0.05, 0.05)
	gO = randf_range(-0.05, 0.05)
	bO = randf_range(-0.05, 0.05)
	
func _on_animation_player_animation_finished():
	$AnimationPlayer.play("Background_Movement")

func transition_to_color(color: Color):
	trans_color = true
