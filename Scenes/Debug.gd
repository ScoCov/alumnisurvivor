extends Node2D

const punch_scene = preload("res://Abilities/Punch.tscn")
const enemy_unit_scene = preload("res://Entities/EnemyUnit.tscn")
const enemy_debug_resource = preload("res://Resources/Data/Enemies/DebugEnemy.tres")
const enemy_spawn_point:= Vector2(72,48)
const item_resource: Item = preload("res://Resources/Data/Items/RunningShoes.tres")
@export var item1: Item
@export var item2: Item

func _ready():
	$'StudentPlayer'.student = Global.SELECTED_STUDENT
	$'StudentPlayer'.besty = Global.SELECTED_BESTY
	($'StudentPlayer'.stats.attributes["ATTRIBUTE_HEALTH"] as HealthComponent).zero_health.connect(get_tree().change_scene_to_file.bind("res://Scenes/MainMenu.tscn"))
	($'StudentPlayer'.stats.attributes["ATTRIBUTE_HEALTH"] as HealthComponent).low_health.connect(func(): print("LOW HEALTH") )
	var punch = punch_scene.instantiate()
	punch.player_student = $StudentPlayer
	var enemy = enemy_unit_scene.instantiate()
	enemy.position = enemy_spawn_point
	enemy.player = $'StudentPlayer'
	add_child(enemy)
	$'StudentPlayer'.add_ability(punch)
	$ItemPickUp/Sprite2D.texture = item1.image
	$ItemPickUp2/Sprite2D.texture = item2.image
	
func _process(_delta):
	pass
	if not self.has_node("EnemyUnit"):
		var enemy = enemy_unit_scene.instantiate() as EnemyEntity
		enemy.name = "EnemyUnit"
		enemy.player = $'StudentPlayer' as StudentPlayer
		enemy.position = enemy_spawn_point
		enemy.enemy = enemy_debug_resource
		self.add_child(enemy as EnemyEntity)
		

func _on_area_2d_body_entered(body):
	if body is StudentPlayer:
		body.item_list.add_item(item1)
		
func _on_area_2d_body_entered2(body):
	if body is StudentPlayer:
		body.item_list.add_item(item2)
