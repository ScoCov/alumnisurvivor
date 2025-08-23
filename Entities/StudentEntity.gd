class_name StudentEntity
extends CharacterBody2D

signal take_damage
signal death

@export var student: StudentResource
#var besty: StudentResource
## Import a Student Resource to obtain unique data.
var global_projectile_container: Node
var invulnerable: bool = false
var _enemy_refs: Array[EnemyEntity]

func _ready():
	if student:
		$Sprite.texture = student.doll
		var ability = student.starting_ability.id
		var ability_packed_scene = load("res://Entities/Abilities/%s.tscn" % ability)
		var new_ability = ability_packed_scene.instantiate()
		new_ability.player = self
		$Ability1.add_child(new_ability)
		
func _process(_delta):
	$Label.text = "Enemy Inside Bubble Count: (%s)" % str(len(_enemy_refs))
	if not invulnerable and len(_enemy_refs) > 0:
		take_damage.emit(_enemy_refs[0])

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
