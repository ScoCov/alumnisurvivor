class_name Stink_Pool
extends CharacterBody2D

const poison_effect = preload("res://Resources/Data/StatusEffects/poison_status.tres")

@export var radius: float = 150
@export var duration_time: float = 4.0
@export var tick_rate: float = 0.5
@export var color: Color = Color.GREEN
@export var parent_entity: Entity
@export var parent_ability: Ability_Entity

@onready var hitbox = $Hitbox/CollisionShape2D
@onready var tick = $Tick
@onready var duration = $Duration

var entity_pool: Array[Entity]
var _pulse = 1

func _draw():
	draw_circle(Vector2.ZERO,radius, color, true)

func _ready():
	duration.wait_time = duration_time
	tick.wait_time = tick_rate
	hitbox.shape.radius = radius
	
func _process(delta):
	_pulse += 5 * delta
	color.a = sin(_pulse)
	queue_redraw()

func infect_all():
	if len(entity_pool) > 0:
		for entity in entity_pool:
			apply_status_effect(entity)

func apply_status_effect(entity: Enemy_Entity):
	entity.status_effects.add_status_effect_entity(poison_effect, parent_ability)

func _on_hitbox_body_entered(body):
	add_entity_to_pool(body)
	apply_status_effect(body)

func _on_hitbox_body_exited(body):
	remove_entity_from_pool(body)
	
func add_entity_to_pool(_entity: Entity):
	if _entity is Enemy_Entity:
		var extant_entity = entity_pool.any(func(_entity_): return _entity_ == _entity)
		if not extant_entity:
			entity_pool.append(_entity)
				
func remove_entity_from_pool(_entity: Entity):
	if _entity is Enemy_Entity:
		var extant_entity = entity_pool.filter(func(_entity_): return _entity_ == _entity)
		if extant_entity:
			entity_pool.remove_at(entity_pool.find_custom(func(_entity_): return _entity_ == _entity))

func _on_duration_timeout():
	queue_free()

func _on_tick_timeout():
	infect_all()
