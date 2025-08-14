extends CharacterBody2D
class_name StudentPlayer

## Import a Student Resource to obtain unique data.
@export var student: Student
@export var besty: Student

@onready var item_list: ItemManager = $Items
@onready var stats: Stats = $Stats


func _ready():
	$'Sprite2D'.texture = student.doll
	if not besty:
		besty = Global.SELECTED_BESTY
	
func _init():
	pass
	
func _process(_delta):
	pass
	
func _physics_process(_delta):
	pass
	
func add_ability(_ability: Ability):
	pass
	#$'Abilities'.add_child(_ability)
	
#func take_damage(damage_dealing_stragedy: DamageBase):
	## Instead of having the enemies have a player detection collision check, have the player simple have an
	## enemy collision check - reducing the number of checks. 
	
	## Idea difference being, that everytime a thing is entering the enemies radius it will do a check to see 
	## what it is, and when there's potentially dozens of enemies that could lag out computers. However, if
	## there is only a check to see if an ememy has entered the player's space will it do damage. 
	##
	## Then, we can have it check projectiles entering the area, if the target is  the player, then do damage.
	## How to handle projectiles optimaly is going to be a challenge. They will be traveling and can strike 
	## both enemy and player. They can also collide with walls. I believe the least checks for that will
	## be done via the projectile itself, due to the sheer number of things needing to be detected by it. 
	#pass


func _on_enemy_detection_body_entered(body):
	if body is EnemyEntity: #or Projectile
		print('Enemy')
		#take_damage(body.attack())
	#if body is Projectile:
		#take_damage(body.attack())
		#pass
