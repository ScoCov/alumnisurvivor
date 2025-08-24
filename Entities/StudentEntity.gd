class_name StudentEntity
extends CharacterBody2D

signal take_damage
signal death

@export var student: StudentResource
@export var game_logic: GameLogic
var global_projectile_container: Node
var invulnerable: bool = false
var _enemy_refs: Array[EnemyEntity]

func _ready():
	if not student: return
	$Sprite.texture = student.doll
	var ability_packed_scene = load("res://Entities/Abilities/%s.tscn" % student.starting_ability.id)
	var new_ability = ability_packed_scene.instantiate()
	new_ability.player = self
	$Ability1.add_child(new_ability)
		
func _process(_delta):
	if invulnerable:
		$Sprite.self_modulate = (Color(1, .5, .5, .80) 
			if ceili($'InvulTimer'.time_left * 10) % 2 == 0 
			else Color(1, 1, 1, 1))
	else:
		$Sprite.self_modulate = Color(1, 1, 1, 1)
		
	if not invulnerable and len(_enemy_refs) > 0:
		take_damage.emit(_enemy_refs[randi_range(0, len(_enemy_refs) - 1)])

func _on_take_damage(enemy: EnemyEntity):
	if enemy and not invulnerable:
		$Composition/Health.current_health -= enemy.get_node("Composition/Damage").value
		invulnerable = true
		$InvulTimer.start()
		if $Composition/Health.current_health < 1:
			death.emit()
		
func _on_death():
	call_deferred("_change_scene")
	
func _change_scene():
	get_tree().change_scene_to_file("res://Scenes/GameMenus/GameMenu.tscn")

func _on_invul_timer_timeout():
	invulnerable = false
	$EnemyDetection.monitoring = true

func _on_enemy_detection_body_entered(body):
	if body is EnemyEntity:
		_enemy_refs.append(body)
		take_damage.emit(body)

func _on_enemy_detection_body_exited(body):
	_enemy_refs.remove_at(_enemy_refs.find(body))

func experience_detection_entered(experience_node):
	if not experience_node is ExperienceEntity: return
	experience_node.target_player = self
	experience_node.chase = true

func experience_detection_exit(experience_node):
	if not experience_node is ExperienceEntity: return
	experience_node.chase = false

func experience_collector(experience_node):
	if not experience_node is ExperienceEntity: return  ## If it isn't ExperienceEntity exit
	if get_parent():
		get_parent().experience.gain_xp(experience_node.xp) 
	experience_node.queue_free() ## Destroy XP Node
