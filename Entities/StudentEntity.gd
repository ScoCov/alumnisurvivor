class_name StudentEntity
extends CharacterBody2D

#region Description
## This entity is the base entity used by the playable characters, the Students. Each student
## will inherit their class/scene from this entity. 
##
## Everything that is inside this file, StudentEntity.tscn, will be applied to all other students. If
## changes are made on this, that change will be applied to all other Student Entities that inherit 
## this class. The only exceptions will be when the Student overrides a default value, those 
## will not rever to default values when this file is changes (and saved). 
#endregion

signal take_damage ## Call this to pass in a Damage_Carrier Clas [When made]
signal death ## This will allow us to initiate death animations and logic. 

const DEFAULT_MOVEMENT_SPEED: float = 150

#@export var game_logic: GameLogic  ## Every map should have a node of GameLogic made and applied with the script GameLogic.gd
@export var student: StudentResource = Global.SELECTED_STUDENT ## Basic data about the student stored elsewhere in a Resource file. 
@export var health: Dictionary = {"current_health": 10, "max_health": 10}
@export var movement: Dictionary = {"movement_speed": 100,"dash_speed": 1000 }
@export var is_combat: bool = true:
	set(value):
		is_combat = value
		if not is_combat: 
			$Data.queue_free()
@export var global_projectile_container: Node ## Easy way to pass this object down to Abiltiies so when they spawn objects they are independent of the user.
## Makes the node, PlayerExperience, with the ExperienceComponent class, easier to access.
@onready var pick_up_detection: Area2D = $PickUpDetection
var experience 
var items
var states 


## Populate this with enemies that enter the enemy detection Area2D node.
var _enemy_refs: Array[EnemyEntity] 
var invulnerable: bool = false ## Used for invulnerability frames. 
var is_level_up: bool = false


func _ready():
	render_student()
	if is_combat:
		experience = $Data/Experience
		items = $Data/Items
		states = $Data/States
		experience.level_up.connect(func(): 
			is_level_up = true
			get_tree().paused = true )
		
func _process(_delta):
	if not is_combat: pass
	## If Invulnerability is not active, allow damage. This will be from one source at random in the enemy_ref.
	if not invulnerable and len(_enemy_refs) > 0: 
		take_damage.emit(_enemy_refs[randi_range(0, len(_enemy_refs) - 1)])

func render_student() -> void:
	$Visuals/Head/Hair.texture = student.hair
	$Visuals/Head/Eyebrows.texture = student.eyebrows
	$Visuals/Head/Eyes.texture = student.eyes
	$Visuals/Head/Mouth.texture = student.mouth

func _on_take_damage(entity: Variant):
	if not entity or invulnerable: return
	if entity is EnemyEntity:
		##TODO: Update Enemy Entity
		$Composition/Health.current_health -= entity.get_node("Composition/Damage").value
		invulnerable = true
		$InvulTimer.start()
	if entity is Projectile:
		##TODO: Update Projectile Entity
		health.current_health -= entity.get_node("Composition/Damage").value
		invulnerable = true
		$InvulTimer.start()
			
	
## This controls turn off Invulnerability once its' time is up. 
func _on_invul_timer_timeout():
	invulnerable = false
	$EnemyDetection.monitoring = true

## When an Enemy Entity enters the Enemy Detection node's radius, add it to the enemy_ref variable.
## This will act as a way for the Student to point to an enemy within melee-damage radius 
## repeatedly take damage from them.
func _on_enemy_detection_body_entered(body: EnemyEntity):
	if body is EnemyEntity:
		_enemy_refs.append(body)
		take_damage.emit(body)

## When an Enemy Entity leave the Enemy Detection node's radius, this will remove that enemy from
## the Student's reference to it. This is to prevent the Enemy from continuously damaging the Student,
## despite the Enemy no longer being the the detection area.
func _on_enemy_detection_body_exited(body):
	_enemy_refs.remove_at(_enemy_refs.find(body))

## Whenever an experience node is detected, supply the Student to the node, so that it knows where
## the player will be, even when they leave the pick up radius.
func experience_detection_entered(experience_node: ExperienceEntity):
	#if not experience_node is ExperienceEntity: return
	experience_node.target_player = self
	experience_node.chase = true

## Tells experience nodes that leave the pick up radius to stop chasing the Student.
func experience_detection_exit(experience_node: ExperienceEntity):
	#if not experience_node is ExperienceEntity: return
	experience_node.chase = false

## Whenever an Experience node reaches a student, deliver its' xp package and expire.
func experience_collector(experience_node: ExperienceEntity):
	#if not experience_node is ExperienceEntity: return  ## If it isn't ExperienceEntity exit
	experience.gain_xp(experience_node.xp) 
	experience_node.queue_free() ## Destroy XP Node
	
func doll_update(_student: StudentResource) -> void:
	student = _student
	render_student()
