class_name Ability
extends Resource


## Development Related Name
@export var name: String
## Name to show the player
@export var display_name: String
@export_multiline var description: String

@export_group("Tags")
## Global tags associating the ability with specific concepts through out the game.
@export var tags: Array[Global.tag]

@export_category("Stats")
## Damage the ability will do per instance of damage dealt. [Default = 0]
@export var damage: float = 0
## In ms (miliseconds) - Time in between attacks. [Default = 100]
@export var cooldown: float = 100
## This is the movement speed of the object that the ability will use. This in effect
## will speed up the attack animation itself, but not the time between attacks. [Default = 100]
@export var attack_speed: float = 100 
## Determines the distance at which the move can either travel, in the case 
## of the projectile, or the area of effect for an AOE Ability. [Default = 100]
@export var range: float = 100 

@export_group("Attack Meta")
## Determines the type of AttackTypeStragety should be used to create move effect. [Default = None]
@export_enum("Thrust", "AOE", "Arc", "Wave", "None") var attack_type: String = "None"
## Determines the type of damage to be dealt the the effected entity. [Default = None]
@export_enum("Physical", "Sonic", "None") var damage_type: String = "None"
## Determines which formula to use when calculating range effectiveness. [Default = None]
@export_enum("Range", "Melee", "None") var range_type: String = "None"

@export_group("Images")
## This is what will be shown outside gameplay, this will be a simple static image of the object
@export var menu_image: Texture 
## This is the background image for the item to have as a back-drop.
@export var menu_image_backgroud: Texture

## Caled Every tick
func on_update():
	pass

## Called when the ability is active phase
func on_active():
	pass
	
## Called when the ability is in recovery phase
func on_recover():
	pass
	
## Called when the ability is ready to be triggered again
func on_ready():
	pass
	
func on_cooldown():
	pass
	
## Called when the ability is upgraded
func on_upgrade():
	pass
