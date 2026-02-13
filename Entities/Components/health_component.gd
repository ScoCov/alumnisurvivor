class_name Health_Component
extends Node

signal damage_taken
signal damage_negated
signal damage_healed
signal damage_lethal

const hit_colors: Array[Color] = [Color.GREEN, Color.RED]
const RESOURCE = preload("res://Resources/Data/Attributes/health.tres")
const REGEN_RES = preload("res://Resources/Data/Attributes/health_regen.tres")
const HEALTH_REGEN_DEFAULT_WAIT_TIME: float = 10
const ARMOR_RES = preload("res://Resources/Data/Attributes/armor.tres")
const _taking_damage_particles:= preload("res://Entities/Effects/taking_damage.tscn")
const _healing_damage_particles:= preload("res://Entities/Effects/healing_damage.tscn")

## Allows cheats to be applied.
@export_group("Debug Mode")
@export var debug: bool = false

@export_category("Health")
## This is the health the character will start with at the beginning of the game.
## Eventually, the player will have the option to increase this value.
const MAX_HEALTH: = 10
@export var maximum_health: int = 10:
	get():
		if get_parent() is Student_Entity:
			return _get_maximum_health()
		else:
			return maximum_health

@export var current_health: int = 10:
	set(value):
		current_health = value
		if current_health < 1:
			damage_lethal.emit()
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
		if get_parent().get_children().any(func(child): return child.name.to_lower() == "items"):
			value = get_parent().items.get_attribute_bonus(REGEN_RES.id)
		return value > 0

@export_group("Armor")
## Armor will be applied to a logarithmic function, to provide a value. log(armor) * 100
@export var armor: int = 0;
@export var armor_reduction_base: float = 10
## Flat value to reduce damage
@export var damage_reduction: int = 0

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

var active_state: State:
	set(value):
		pass
	get:
		if has_node("Statemachine"):
			return ($Statemachine as State_Machine).current_state
		return null

func _process(delta):
	if current_health < maximum_health and _can_regen and health_regen.is_stopped():
		var value = HEALTH_REGEN_DEFAULT_WAIT_TIME * get_parent().items.get_attribute_bonus(REGEN_RES.id)
		health_regen.wait_time = regen_base * (regen_base/(1 + ((value -1) / regen_scale)))
		health_regen.start()

func _get_configuration_warnings():
	var msg: Array[String]
	if not get_parent() is Entity:
		msg.append("Health Component must be a child in an Entity class.")
	return msg
	
func attempt_damage(damage_dealt: float):
	if invulnerable: return
	
	## Calculate Armor Reduction
	var armor_mod = 1
	if get_parent() is Student_Entity:
		armor_mod = Utility.round_to_dec( _armor_reduction_value(get_parent().items.get_attribute_bonus(ARMOR_RES.id)), 2)
	
	## Deal Damage
	current_health += floor(damage_dealt * armor_mod)
	## Determine if invul and what type of damage to emit
	if damage_dealt < 0: 
		damage_taken.emit()
		invulnerable = true
		invulnerability_timer.start()

	elif damage_dealt > 0:
		damage_healed.emit()
	elif damage_dealt == 0:
		damage_negated.emit()
	emit_hit_indication(get_parent(), damage_dealt)

func _armor_reduction_value(value: float)-> float:
	return (armor_reduction_base) / (armor_reduction_base + value)

func _on_invulnerability_timer_timeout():
	invulnerability_timer.stop()
	invulnerable = false

func emit_hit_indication(entity: Entity, amount: float):
	strike.position = entity.position
	strike.particle.emitting = true

func _get_maximum_health() -> float:
	var bonus_max_health = 0
	if get_parent().get_children().any(func(child): return child.name.to_lower() == "items"):
		bonus_max_health = get_parent().items.get_attribute_bonus(RESOURCE.id)
	return floor(MAX_HEALTH + bonus_max_health)

func _passive_healing():
	if current_health < maximum_health and _can_regen:
		attempt_damage(1)
	## If Health is still below max, then allow the timer to continue. 
	if current_health < maximum_health and _can_regen:
		var value = HEALTH_REGEN_DEFAULT_WAIT_TIME * get_parent().items.get_attribute_bonus(REGEN_RES.id)
		health_regen.wait_time = regen_base * (regen_base/(1 + ((value -1) / regen_scale)))
		health_regen.start()
