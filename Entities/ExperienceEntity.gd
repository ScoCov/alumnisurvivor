class_name ExperienceEntity
extends CharacterBody2D

## Assign the base level of XP this node will give. 
@export var xp: float = 1:
	set(value):
		xp = value
	get:
		var multiplier: float = 1
		match rank:
			level.None:
				multiplier = 0
			level.Low:
				multiplier = 1
			level.Medium:
				multiplier = 1.5
			level.High:
				multiplier = 2
		return xp * multiplier
## Assign the rank of the node to determine what the xp's value scaling will result in.
@export var rank: level
enum level {None, Low, Medium, High, Unique}

## If the Experience entity has a target player, then it will try and follow, if it doesn't then it will sit here.
@export var target_player: StudentEntity
var chase: bool = false
	
func _physics_process(delta):
	if not chase: return
	var speed: float = (target_player.get_node("Composition/MovementSpeed").value * 1.1)
	var direction: Vector2 = position.direction_to(target_player.position)
	velocity = direction * speed 
	move_and_slide() 
