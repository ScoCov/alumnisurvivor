@tool
class_name Spawn_Zone
extends Node2D

@export var MARGIN: float = 10.0

## Zone will grab the CollisionShape2D that is the child of the Area2D child.
## Without those nodes being children of this Spawn_Zone, the Spawn_Zone will break.
var zone: CollisionShape2D:
	set(value):
		pass
	get():
		return get_child(0).get_child(0)

func _get_configuration_warnings():
	var msg: Array[String] 
	if not get_child(0) is Area2D:
		msg.append("No Area2D")
	if get_child_count() > 1:
		msg.append("Spawn Zone should only have 1 child.")
	return msg

	
## Get Vector2 position values within the spawn_zone.	
func get_spawn_vector2(width: float,height: float) -> Vector2:
	var x = zone.global_position.x
	var y = zone.global_position.y
	var w = zone.shape.get_rect().size.x
	var h = zone.shape.get_rect().size.y
	var left_edge = x - (w/2) + MARGIN
	var right_edge = (x + (w/2)) - (width + MARGIN)
	var top_edge = y - (h/2) + MARGIN
	var bottom_edge = (y + (h/2)) - (height + MARGIN)
	var xRand = randf_range(left_edge,right_edge)
	var yRand = randf_range(top_edge,bottom_edge)
	return Vector2(xRand,yRand)
