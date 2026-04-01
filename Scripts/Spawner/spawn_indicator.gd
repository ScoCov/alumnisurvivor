class_name Spawn_Inidcator
extends Node2D

signal entity_spawned

@export var duration: float = 1.0
@export var alpha: float = 1.0
@export_group("Reposition")
@export var max_distance_to_player: float = 500 ## Maximum distance an entity can spawn from the player.
@export var min_distance_to_player: float = 250 ## Closest distance an entity can spawn from the player. 

var entity: Entity
var container: Node2D

func _ready():
	modulate.a = alpha
	$Duration.wait_time = duration
	$AnimationPlayer.speed_scale = duration
	$Warning.visible = true
	$Indicate.visible = false
	$AnimationPlayer.play("warning")
		
# Once the delay in spawn is reached, play the spawn animation.
func _on_duration_timeout():
	$AnimationPlayer.play("spawn")

## If player steps on the spawn point, then move it and restart the timer.
func _on_area_2d_body_entered(body):
	$Duration.stop()
	$Duration.start(0)
	position = _get_position(body.position)
	
## Provides a Vector2 using ranges from the max_distance_to_player and min_distance_to_player as a means to determines spawns for individualt entity.
func _get_position(_origin: Vector2) -> Vector2:
	var new_position:= Vector2(randf_range(-max_distance_to_player, max_distance_to_player),randf_range(-max_distance_to_player, max_distance_to_player)) + _origin
	var distance_to_player: float = new_position.distance_to(_origin)
	if distance_to_player < min_distance_to_player or distance_to_player > max_distance_to_player:
		new_position = _get_position(_origin)
	return new_position

## Use the entity and container provided to spawn in the contained entity.
func spawn_entity(): 
	entity.position = position
	container.add_child(entity)
	self.queue_free() ## Remove Indicator.
