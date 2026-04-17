class_name Projectile
extends CharacterBody2D

signal decay
signal collided

enum TYPE {SPHERE, ROD, BULLET, BOMB}
enum MOVEMENT {STRAIGHT, WAVE}

@export var type: Projectile.TYPE
@export var movement: Projectile.MOVEMENT
@export var shape: Shape2D ## Hitbox Area
@export var texture: Texture ## Visual

@export_group("Target and Direction")
@export var target: Vector2 ## Location
@export var direction: Vector2
@export var angle: float = 0.0

@export_group("Entities")
@export var parent_ability: Ability_Entity
@export var parent_entity: Entity

@export_category("Stats")
@export_range(0,1000, 0.1) var speed: float= 75 ## Projectile Travel Speed
@export_range(0,999) var pierce: int = 0 ## Number of Enemies that can be penetrated without destorying the Projectile
@export_range(0,999) var bounce: int = 0 ## Number of Enemies that the projectile will bounce between, after initial contact.
@export_range(0.05, 10, 0.05) var lifetime: float = 1.5 ## If no collision happens, then projectile will despawn after the time given. [Default = 1.5]
@export_range(50, 1000, 0.5) var max_range: float = 500 ## If no collision happens, the projectiles maximum distance before dispawning. [Default = 500]
@export_range(0.1, 5, 0.1)var area: float = 1 ## Scale Modifier. [Default = 1.0]
@export_range (-100, 100, 0.5) var knockback: float = 0.0

@onready var body_collision = $CollisionShape2D
@onready var sprite_2d = $Sprite2D

var start_position: Vector2

func _ready():
	get_tree().create_timer(4).timeout.connect(func(): queue_free())
	scale = scale * area
	sprite_2d.texture = texture
	start_position = global_position
	
func _process(_delta):
	if start_position.distance_to(global_position) >= max_range:
		max_distance_reached()
	velocity = direction * speed
	#move_and_collide(velocity)
	move_and_slide()
	
func get_damage_rider() -> Damage_Rider:
	call_deferred("emit_signal", "collided")
	return Damage_Rider.new(parent_entity,parent_ability,parent_entity.items)
	
func max_distance_reached():
	decay.emit()

func _on_collided():
	queue_free()
