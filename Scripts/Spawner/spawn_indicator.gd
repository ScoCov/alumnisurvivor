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
var spawn_zone: Spawn_Zone
@onready var collision_shape_2d = $Area2D/CollisionShape2D

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
func _on_area_2d_body_entered(_body):
	$Duration.stop()
	$Duration.start(0)
	position = _get_position()
	
func _get_position():
	return spawn_zone.get_spawn_vector2(collision_shape_2d.shape.radius, collision_shape_2d.shape.radius)

	## Use the entity and container provided to spawn in the contained entity.
func spawn_entity(): 
	entity.position = position
	container.add_child(entity)
	entity_spawned.emit()
	self.queue_free() ## Remove Indicator.
