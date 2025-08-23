extends CharacterBody2D
class_name EnemyEntity

signal death
signal take_damage

var player: StudentEntity
var spawner_ref: EnemySpawner		
@export var resource: EnemyResource


func _physics_process(_delta):
	if $Composition/Health.current_health < 1:
		death.emit()

func _on_death():
	queue_free()

func _on_take_damage(damage_amount: float, source: Variant):
	if damage_amount >= 1:
		$Composition/Health.current_health -= damage_amount
	if $Composition/Health.current_health < 1:
		death.emit()

