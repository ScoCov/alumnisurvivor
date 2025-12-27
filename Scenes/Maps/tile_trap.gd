extends Area2D

@export_enum("Damage", "Heal", "Status Effect") var tile_mode: String = "Damage"
@export var over_heal: bool = false
@export var damage_amount: float = 1
@export var tile_color: Color
@export var cooldown: float
@export var status_effect: Status_Effect_Resource
var entities_in_range: Array[CharacterBody2D]

const SLOW_STATUS: PackedScene = preload("res://Entities/StatusEffects/Statuses/slow_status.tscn")
const HASTE_STATUS: PackedScene = preload("res://Entities/StatusEffects/Statuses/haste_status.tscn")

func _ready():
	$Activation.wait_time = cooldown
	$ColorRect.color = tile_color

func _process(_delta):
	pass

## Determines which tile type is active and will use the appropriate application.
func activate_trap(entity: CharacterBody2D):
	match tile_mode:
		"Damage":
			activate_damage(entity)
		"Heal":
			activate_heal(entity)
		"Status Effect":
			activate_status(entity)
	
func activate_status(entity: CharacterBody2D):
	if not status_effect: return
	print("Activating Trap: %s [%s]" % [tile_mode, status_effect.status_name])
	var status: Status_Effect_Entity = self[status_effect.status_file_name.to_upper()].instantiate()
	status.entity = entity
	if status is Status_Slow or Status_Haste:
		status.speed_modification = damage_amount
	entity.status_effects.add_child(status)

func activate_damage(entity: CharacterBody2D):
	var entity_health_comp: Health_Component = entity.health
	entity_health_comp.attempt_damage(self, -damage_amount)
	
func activate_heal(entity: CharacterBody2D):
	var entity_health_comp: Health_Component = entity.health
	entity_health_comp.attempt_damage(self, damage_amount)
	
func _on_body_entered(body):
	if body is Student_Entity or Enemy_Entity:
		entities_in_range.append(body)

func _on_body_exited(body):
	if body is Student_Entity or Enemy_Entity:
		var index = entities_in_range.find_custom(func(ent): return ent == body)
		entities_in_range.remove_at(index)

func _on_activation_timeout():
	if len(entities_in_range) > 0:
		for entity in entities_in_range:
			activate_trap(entity)
