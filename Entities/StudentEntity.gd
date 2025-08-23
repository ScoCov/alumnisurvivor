class_name StudentEntity
extends CharacterBody2D

signal take_damage
signal death

@export var student: StudentResource
#var besty: StudentResource
## Import a Student Resource to obtain unique data.
var global_projectile_container: Node

func _ready():
	if student:
		$Sprite.texture = student.doll
		var ability = student.starting_ability.id
		var ability_packed_scene = load("res://Entities/Abilities/%s.tscn" % ability)
		var new_ability = ability_packed_scene.instantiate()
		new_ability.player = self
		$Ability1.add_child(new_ability)
		
	
func _process(_delta):
	pass
	 
func _on_enemy_detection_body_entered(body):
	if body is EnemyEntity:
		take_damage.emit(body)

func _on_take_damage(enemy: EnemyEntity):
	if enemy:
		$Composition/Health.current_health -= enemy.get_node("Composition/Damage").value
	if $Composition/Health.current_health < 1:
		death.emit()
		


func _on_death():
	get_tree().change_scene_to_file("res://Scenes/GameMenus/GameMenu.tscn")
