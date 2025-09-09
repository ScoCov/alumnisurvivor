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

@export var game_logic: GameLogic  ## Every map should have a node of GameLogic made and applied with the script GameLogic.gd
@export var health: HealthComponent
@export var global_projectile_container: Node ## Easy way to pass this object down to Abiltiies so when they spawn objects they are independent of the user.

## Makes the node, PlayerExperience, with the ExperienceComponent class, easier to access.
@onready var experience: ExperienceComponent = $Experience
@onready var items: ItemManager = $Items
@onready var pick_up_detection: Area2D = $PickUpDetection
@onready var student: StudentResource = Global.SELECTED_STUDENT## Basic data about the student stored elsewhere in a Resource file. 
@onready var health_state: HealthState = get_node("Composition/Health/StateMachine").current_state


var _enemy_refs: Array[EnemyEntity] ## Populate this with enemies that enter the enemy detection Area2D node.
var invulnerable: bool = false ## Used for invulnerability frames. 
var is_level_up = false

func _init():
	student = Global.SELECTED_STUDENT
	
func _ready():
	student = Global.SELECTED_STUDENT
	## Assign Experience's level up logic
	experience.level_up.connect(func(): 
		is_level_up = true
		get_tree().paused = true )
	## Load in the Student's given starting ability and 'equip' it. 
	var ability_packed_scene = load("res://Entities/Abilities/%s.tscn" % student.starting_ability.id) 
	var new_ability = ability_packed_scene.instantiate()
	new_ability.entity = self
	$Ability1.add_child(new_ability)
		
func _process(_delta):
	## Flash player with a red overlay (self modulate) when they have been injured and invulnerability is active.
	## TODO: When a Health State is created, move this function over to that.
	#health_state = health.get_child(0).current_state
	if invulnerable: 
		$Sprite.self_modulate = (Color(1, .5, .5, 1) 
			if ceili($'InvulTimer'.time_left * 10) % 2 == 0 
			else Color(1, 1, 1, 1))
	else:
		$Sprite.self_modulate = Color(1, 1, 1, 1)
	#$Label.text = "Health-State: %s" % health.get_child(0).current_state.name
	## If Invulnerability is not active, allow damage. This will be from one source at random in the enemy_ref.
	if not invulnerable and len(_enemy_refs) > 0: 
		take_damage.emit(_enemy_refs[randi_range(0, len(_enemy_refs) - 1)])
	var collision_shape_2d: CollisionShape2D = $PickUpDetection/CollisionShape2D
	collision_shape_2d.shape.radius = $Composition/PickupRange.value

## TODO: FIX - this will need it's parameter type to be updated so that players can interact with
## projectiles shot by enemies or from enviromental means. 
func _on_take_damage(entity: Variant):
	if not entity or invulnerable: return
	if entity is EnemyEntity:
		$Composition/Health.current_health -= entity.get_node("Composition/Damage").value
		invulnerable = true
		$InvulTimer.start()
	if entity is Projectile:
		health.current_health -= entity.get_node("Composition/Damage").value
		invulnerable = true
		$InvulTimer.start()

			
## Used to call another function in a que - to help the game not bungle up on itself.
func _on_death(): 
	call_deferred("_change_scene")
	 
## If the player is dead, go back to the game menu for easier testing. 
func _change_scene():
	get_tree().change_scene_to_file("res://Scenes/GameMenus/GameMenu.tscn")
	
## This controls turn off Invulnerability once its' time is up. 
func _on_invul_timer_timeout():
	invulnerable = false
	$EnemyDetection.monitoring = true

## When an Enemy Entity enters the Enemy Detection node's radius, add it to the enemy_ref variable.
## This will act as a way for the Student to point to an enemy within melee-damage radius 
## repeatedly take damage from them.
func _on_enemy_detection_body_entered(body):
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
func experience_detection_entered(experience_node):
	if not experience_node is ExperienceEntity: return
	experience_node.target_player = self
	experience_node.chase = true

## Tells experience nodes that leave the pick up radius to stop chasing the Student.
func experience_detection_exit(experience_node):
	if not experience_node is ExperienceEntity: return
	experience_node.chase = false

## Whenever an Experience node reaches a student, deliver its' xp package and expire.
func experience_collector(experience_node):
	if not experience_node is ExperienceEntity: return  ## If it isn't ExperienceEntity exit
	experience.gain_xp(experience_node.xp) 
	experience_node.queue_free() ## Destroy XP Node
