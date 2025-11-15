extends Area2D

@export var heal: bool = false
@export var over_heal: bool = false
@export var damage_amount: int = 1
var entity: CharacterBody2D

func _process(_delta):
	if entity:
		var damage: int = floor(damage_amount * (-1 if not heal else 1))
		if heal and over_heal:
			var _damage
			var overhealth_maximum = entity.health.maximum_health + entity.health.overhealth_maximum_limit
			var real_damage_total = damage + entity.health.current_health
			if real_damage_total > overhealth_maximum:
				damage = overhealth_maximum - entity.health.current_health
			entity.health.attempt_damage(self, damage)
		elif heal and not over_heal:
			if entity.health.current_health <= entity.health.maximum_health:
				if damage + entity.health.current_health > entity.health.maximum_health:
					damage = entity.health.maximum_health - entity.health.current_health
				entity.health.attempt_damage(self, damage)
		elif not heal:
			if entity.health.current_health > 0: 
				entity.health.attempt_damage(self, damage)
	
func _on_body_entered(body):
	if body is Student_Entity or Enemy_Entity:
		entity = body

func _on_body_exited(body):
	if body is Student_Entity or Enemy_Entity:
		entity = null
