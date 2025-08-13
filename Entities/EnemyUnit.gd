extends CharacterBody2D
class_name EnemyEntity

@export var enemy: EnemyBase
@export var player: StudentPlayer
@onready var stats: Node = $Stats
@onready var statemachine = $'State Machine'
@onready var collision_damage_strategy

func _ready():
	$'Sprite2D'.texture = enemy.image
	(stats.attributes["ATTRIBUTE_HEALTH"] as HealthComponent ).zero_health.connect(self.queue_free)
	collision_layer = 2
	collision_mask = 2


#func _on_hitbox_body_entered(body):
	#if body is StudentPlayer:
		#if body.stats.attributes.has("ATTRIBUTE_HEALTH"):
			#var damage = (stats.attributes["ATTRIBUTE_DAMAGE"] as DamageComponent).value
			#body.stats.attributes["ATTRIBUTE_HEALTH"].take_damage(damage)
			### Apply Knockback.
