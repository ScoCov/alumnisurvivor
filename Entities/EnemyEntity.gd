extends CharacterBody2D
class_name EnemyEntity

signal death
signal take_damage

var player: StudentEntity
var spawner_ref: EnemySpawner
@export var resource: EnemyResource

@export_group("Distance Modifiers")
## Used to determine how close an enemy will attempt to get.
@export var player_distance_min: float = 45
## Used to determine how far an enemy will attempt to flea the player.
@export var player_disntance_max: float = 500

func _physics_process(_delta):
	if $Composition/Health.current_health < 1:
		death.emit()

func _on_death():
	queue_free()

func _on_take_damage(damage_amount: float, _source: Variant = null):
	if damage_amount >= 1:
		$Composition/Health.current_health -= damage_amount
	if $Composition/Health.current_health < 1:
		death.emit()

