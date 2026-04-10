class_name Health_Component
extends Node

signal damage_taken
signal damage_negated
signal damage_healed
signal damage_lethal

const HIT_COLORS: Dictionary = {"Heal": Color.GREEN,"Damag": Color.RED, "Critical": Color.GOLD}
const HEALTH_RES = preload("res://Resources/Data/Attributes/health.tres")
const REGEN_RES = preload("res://Resources/Data/Attributes/health_regen.tres")
const HEALTH_REGEN_DEFAULT_WAIT_TIME: float = 10
const ARMOR_RES = preload("res://Resources/Data/Attributes/armor.tres")
const _taking_damage_particles:= preload("res://Entities/Effects/taking_damage.tscn")
const _healing_damage_particles:= preload("res://Entities/Effects/healing_damage.tscn")
const MIN_DODGE_CHANCE: float = 0.0
const MAX_DODGE_CHANCE: float = 0.6

@export var entity: Entity = get_parent()
## Allows cheats to be applied.
@export_group("Debug Mode")
@export var debug: bool = false

@export_category("Health")
## This is the health the character will start with at the beginning of the game.
## Eventually, the player will have the option to increase this value.
const MAX_HEALTH: = 10
@export var maximum_health: int = 10:
	get():
		if get_parent() is Player_Entity:
			return floori(_get_maximum_health())
		else:
			return maximum_health

@export var current_health: int = 10:
	set(value):
		current_health = value
		if current_health < 1 and !is_dead:
			damage_lethal.emit()
			is_dead = true
		if current_health < maximum_health and health_regen.is_stopped():
			health_regen.start()

## Percentage of how much health can be gained passed the maximum health. Default = 0.25 (25%)
@export var over_health_maximum: float = 0.25
var overhealth_maximum_limit: int:
	set(value):
		pass
	get:
		return floor(maximum_health * over_health_maximum)
@export var regen_base: float = 10
#@export var regen_base: float = 5.0
@export var regen_scale: float = 7.225
var _can_regen: bool:
	get():
		var value = 0
		#if get_parent().get_children().any(func(child): return child.name.to_lower() == "items"):
		value = entity.items.get_attribute_bonus(REGEN_RES.id)
		return value > 0

@export_group("Armor")
## Armor will be applied to a logarithmic function, to provide a value. log(armor) * 100
@export var armor: int = 0;
@export var damage_reduction: int = 0
@export var dodge: float = 0.0

@export_group("Invulnerability")
## When true, prevents all damage that would be dealt.
@export var invulnerable: bool = false
## Length of time the player is immune to any damage, after taking damage from an enemy. DEFAULT = 0.33
@export var invulnerability_time: float = 0.33:
	set(value):
		invulnerability_time = value
		if has_node("Invulnerability Timer"):
			$"Invulnerability Timer".wait_time = value

@onready var invulnerability_timer = $"Invulnerability Timer"
@onready var strike = $Strike
@onready var health_regen: Timer = $"Health Regen"

var is_dead: bool = false

var active_state: State:
	set(value):
		pass
	get:
		if has_node("Statemachine"):
			return ($Statemachine as State_Machine).current_state
		return null

func _process(_delta):
	if current_health < maximum_health and _can_regen and health_regen.is_stopped():
		var value = HEALTH_REGEN_DEFAULT_WAIT_TIME * get_parent().items.get_attribute_bonus(REGEN_RES.id)
		health_regen.wait_time = regen_base * (regen_base/(1 + ((value -1) / regen_scale)))
		health_regen.start()

func _get_configuration_warnings():
	var msg: Array[String]
	if not get_parent() is Entity:
		msg.append("Health Component must be a child in an Entity class.")
	return msg
	
func apply_dot_damage(amount: float, status_entity: Status_Effect_Entity):
	current_health -= amount
	_react_to_dot(amount, status_entity)
	
func apply_damage_rider(damage_rider: Damage_Rider):
	if invulnerable: return ## Guard
	var damage_value = damage_rider.deal_damage()
	var reduction_value = get_armor_reduction_value()
	if !has_dodged():
		current_health -= floori(damage_value * reduction_value) - damage_reduction
		_apply_knockback(damage_rider)
		_react_to_damage(damage_rider)
	
func get_armor_reduction_value() -> float:
	var combo = armor + entity.items.get_attribute_bonus("armor")
	return 1 - (combo / (combo + 100))
	
func has_dodged() -> bool:
	return randf_range(0,1) <= clamp(dodge + entity.items.get_attribute_bonus("dodge"), MIN_DODGE_CHANCE,MAX_DODGE_CHANCE)
	
func _apply_knockback(damage_rider: Damage_Rider):
	var kb_value = damage_rider.ability.ability.knockback 
	kb_value += (damage_rider.items.get_attribute_bonus("knockback") if damage_rider["items"] else 0)
	if kb_value != 0:
		entity.movement_component.knockback_effect(damage_rider.ability.direction, kb_value)
			
func _react_to_damage(damage_rider: Damage_Rider):
	## Determine if invul and what type of damage to emit
	var damage_dealt = damage_rider.damage
	current_health -= damage_dealt
	if damage_dealt < 0: 
		damage_taken.emit()
		invulnerable = true
		invulnerability_timer.start()
	elif damage_dealt > 0:
		damage_healed.emit()
	elif damage_dealt == 0:
		damage_negated.emit()

	emit_hit_indication(get_parent(), damage_dealt, damage_rider.is_critical)
	
func _react_to_dot(amount: float, status_effect: Status_Effect_Entity):
	## Determine if invul and what type of damage to emit
	var damage_dealt = amount
	if damage_dealt < 0: 
		damage_taken.emit()
		invulnerable = true
		invulnerability_timer.start()
	elif damage_dealt > 0:
		damage_healed.emit()
	elif damage_dealt == 0:
		damage_negated.emit()

	## Emit_hit_indicator needs a dot version
	emit_dot_indication(status_effect)
	
func _on_invulnerability_timer_timeout():
	invulnerability_timer.stop()
	invulnerable = false

func emit_dot_indication(status_effect: Status_Effect_Entity = null):
	strike.particle.position = get_parent().position
	strike.particle.modulate = status_effect.status_color
	strike.particle.emitting = true

func emit_hit_indication(entity: Entity, _amount: float, is_critical: bool = false):
	strike.position = entity.position
	if is_critical:
		strike.particle.modulate = Color.GOLD
	strike.particle.emitting = true

func _get_maximum_health() -> float:
	var bonus_max_health = 0
	if get_parent().get_children().any(func(child): return child.name.to_lower() == "items"):
		bonus_max_health = get_parent().items.get_attribute_bonus(HEALTH_RES.id)
	return floor(MAX_HEALTH + bonus_max_health)

func _passive_healing():
	if current_health < maximum_health and _can_regen:
		current_health += 1
	## If Health is still below max, then allow the timer to continue. 
	if current_health < maximum_health and _can_regen:
		var value = HEALTH_REGEN_DEFAULT_WAIT_TIME * entity.items.get_attribute_bonus(REGEN_RES.id)
		health_regen.wait_time = regen_base * (regen_base/(1 + ((value -1) / regen_scale)))
		health_regen.start()
