@tool
class_name Health_Component
extends Node

signal damage_taken
signal damage_negated
signal damage_healed
signal damage_lethal

const hit_colors: Array[Color] = [Color.GREEN, Color.RED]

## Allows cheats to be applied.
@export_group("Debug Mode")
@export var debug: bool = false

@export_category("Health")
## This is the health the character will start with at the beginning of the game.
## Eventually, the player will have the option to increase this value.
@export var maximum_health: int = 10;

@export var current_health: int = 10:
	set(value):
		current_health = value
		if current_health < 1:
			damage_lethal.emit()

## Percentage of how much health can be gained passed the maximum health. Default = 0.25 (25%)
@export var over_health_maximum: float = 0.25
var overhealth_maximum_limit: int:
	set(value):
		pass
	get:
		return floor(maximum_health * over_health_maximum)

## Armor will be applied to a logarithmic function, to provide a value. log(armor) * 100
@export var armor: int = 0;
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

var active_state: State:
	set(value):
		pass
	get:
		if has_node("Statemachine"):
			return ($Statemachine as State_Machine).current_state
		return null

const _taking_damage_particles:= preload("res://Entities/Effects/taking_damage.tscn")
const _healing_damage_particles:= preload("res://Entities/Effects/healing_damage.tscn")

func _get_configuration_warnings():
	var msg: Array[String]
	if not get_parent() is Entity:
		msg.append("Health Component must be a child in an Entity class.")
	return msg
	
func attempt_damage(damage_dealt: float):
	if invulnerable: return
	## Deal Damage
	current_health += floor(damage_dealt)
	
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

func _on_invulnerability_timer_timeout():
	invulnerability_timer.stop()
	invulnerable = false

func emit_hit_indication(entity: Entity, amount: float):
	var lbl := Label.new()
	var life_timer:= Timer.new()
	lbl.text = "%s" % abs(amount)
	lbl.modulate = hit_colors[0 if amount > 0 else 1]
	life_timer.autostart = true
	life_timer.wait_time = 0.5
	life_timer.timeout.connect(func(): lbl.queue_free())
	lbl.add_child(life_timer)
	var blank_node:= Node.new() ## Node to creat a static position for text to attach to _will need to make a global [ignores position] Node in Game
	blank_node.add_child(lbl)
	lbl.position = entity.position
	entity.add_child(blank_node)
	
	if amount < 0:
		entity.add_child(_taking_damage_particles.instantiate())
	if amount > 0:
		entity.add_child(_healing_damage_particles.instantiate())
