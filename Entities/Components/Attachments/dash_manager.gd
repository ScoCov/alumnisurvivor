@tool
class_name Dash_Manager
extends Control

const DASH_HARD_CAP: int = 4
const DASH_HARD_MIN: int = 0

@export_range(DASH_HARD_MIN,DASH_HARD_CAP) var max_dashes: int = 1:
	set(value):
		max_dashes = clamp(max_dashes,DASH_HARD_MIN,DASH_HARD_CAP)
		
var dashes: Array[Node]:
	get:
		return get_children() as Array[Node].filter(func(dash_ind: Dash_Indicator): return dash_ind.ready_to_dash)

var cand_dash: bool:
	get():
		return get_children().any(func(dash_ind: Dash_Indicator): return dash_ind.ready_to_dash)

func _get_configuration_warnings():
	var msg: Array[String]
	if get_child_count() > DASH_HARD_CAP:
		msg.append("Too many dash indicators. The Hard Cap [%s] is limited by engine." % DASH_HARD_CAP)
	if get_children().any(func(child): return not child is Dash_Indicator):
		msg.append("Only Dash Indicators can be a child of Dash Manager")
	return msg

func consume_dash():
	dashes[0].ready_to_dash = false
