extends CharacterBody2D
class_name EnemyEntity

@export var enemy: EnemyBase
@export var player: StudentPlayer
@onready var stats: Node = $Stats
@onready var statemachine = $'State Machine'
@onready var collision_damage_strategy

var spawner_ref: EnemySpawner

func _ready():
	$'Sprite2D'.texture = enemy.image
	(stats.attributes["ATTRIBUTE_HEALTH"] as HealthComponent ).zero_health.connect(self.queue_free)
	collision_layer = 2
	collision_mask = 2
	position = get_start_pos(get_rand_vector2(spawner_ref._max)) if spawner_ref else Vector2()

func get_start_pos(rand_vector2: Vector2) -> Vector2:
	var new_vector2 := player.position + rand_vector2
	var new_distance := player.position.distance_to(new_vector2)
	return (new_vector2 if (new_distance > spawner_ref._min) or (new_distance < spawner_ref._max) 
		else get_start_pos(get_rand_vector2(spawner_ref._max)))

func get_rand_vector2(max_dist: float) -> Vector2:
	return Vector2(randf_range(- max_dist, max_dist), randf_range(-max_dist, max_dist))
