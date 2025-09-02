extends EnemyEntity
var ability_scene = preload("res://Entities/Abilities/ThrowBaseball.tscn")

func _ready():
	var new_ability: Ability = ability_scene.instantiate()
	new_ability.entity = self
	new_ability.target_entity = player
	add_child(new_ability)
