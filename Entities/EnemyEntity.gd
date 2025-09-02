extends CharacterBody2D
class_name EnemyEntity

signal death
signal take_damage

var player: StudentEntity
var spawner_ref: EnemySpawner
var _xp_node_scene: PackedScene = preload("res://Entities/ExperienceEntity.tscn")
@export var resource: EnemyResource 

@export_group("Distance Modifiers")
## Used to determine how close an enemy will attempt to get.
@export var player_distance_min: float = 45
## Used to determine how far an enemy will attempt to flea the player.
@export var player_disntance_max: float = 500

## Define Enemy Movement Behavior.
@onready var movement_type: EnemyMovementStyle = EnemyMovementStyle.load_movement_type(resource.move_style)
@onready var health = $Composition/Health
var global_projectile_container: Node ## Easy way to pass this object down to Abiltiies so when they spawn objects they are independent of the user.

func _physics_process(_delta):
	pass
	
func _on_death():
	call_deferred("spawn_xp")
	queue_free()

func _on_take_damage(damage_amount: float, _source: Variant = null):
	var start_hp = $Composition/Health.current_health
	if damage_amount >= 1:
		$Composition/Health.current_health -= damage_amount
		
	if start_hp != $Composition/Health.current_health:
		$AnimationPlayer.play("taken_damage")
	if $Composition/Health.current_health < 1:
		death.emit()

func spawn_xp():
	var xp_node: ExperienceEntity = _xp_node_scene.instantiate()
	xp_node.position = position
	xp_node.rank = resource.experience_group
	spawner_ref.experience_container_ref.add_child(xp_node)
