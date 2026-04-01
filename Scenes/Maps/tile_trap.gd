extends Area2D

@export_enum("Damage", "Heal", "Item", "Status Effect") var tile_mode: String = "Damage"
@export var over_heal: bool = false
@export var damage_amount: float = 1
@export var tile_color: Color
@export var cooldown: float = 0.2
@export var status_effect: Status_Effect_Resource
@export var item: Item_Resource
var entities_in_range: Array[CharacterBody2D]

func _ready():
	$Activation.wait_time = cooldown
	$ColorRect.color = tile_color
	$Label.text = display_text()

func display_text() -> String:
	var msg: String = ""
	match tile_mode:
		"Damage":
			msg = "Damage %s" % damage_amount
		"Heal":
			msg = "Heal %s" % damage_amount
		"Status Effect":
			msg = "%s [%s]" % [tile_mode, status_effect.status_name]
		"Item":
			msg = "%s {%s}" % [tile_mode, item.item_name]
	return msg

## Determines which tile type is active and will use the appropriate application.
func activate_trap(entity: CharacterBody2D):
	match tile_mode:
		"Damage":
			activate_damage(entity)
		"Heal":
			activate_heal(entity)
		"Status Effect":
			activate_status(entity)
		"Item":
			activate_item(entity)
	
func activate_status(entity: CharacterBody2D):
	if not status_effect: return
	var status_effects: Node2D = entity.status_effects
	var index = status_effects.get_children().find_custom(func(st_eff): return st_eff.status_resource == status_effect)
	if index >= 0: ## status_effect exists:
		status_effects.get_child(index).stack_count += 1
		return
		
	var status: Status_Effect_Entity = self[status_effect.status_file_name.to_upper()].instantiate()
	status.entity = entity
	## Get all the status effects currently on the entity
	if status is Status_Slow or status is  Status_Haste:
		status.speed_modification = damage_amount
	entity.status_effects.add_child(status)

func activate_item(entity: Entity):
	if entity is Entity:
		entity.items.add_item(item)

func activate_damage(entity: Entity):
	var entity_health_comp: Health_Component = entity.health
	entity_health_comp.attempt_damage(-damage_amount)
	
func activate_heal(entity: Entity):
	var entity_health_comp: Health_Component = entity.health
	entity_health_comp.attempt_damage(damage_amount)
	
func _on_body_entered(body):
	if body is Entity:
		entities_in_range.append(body)

func _on_body_exited(body: Entity):
	if body is Entity:
		var index = entities_in_range.find_custom(func(ent): return ent == body)
		entities_in_range.remove_at(index)

func _on_activation_timeout():
	if len(entities_in_range) > 0:
		for entity in entities_in_range:
			activate_trap(entity)
