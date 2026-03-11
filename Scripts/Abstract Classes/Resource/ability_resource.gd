class_name Ability_Resource
extends Resource


## Development Related Name
@export var ability_name: String
## Name to show the player
@export var display_name: String
## Name of file
@export var id: String
@export_multiline var description: String

@export_category("Stats") 
## Mutable Fields
@export var base_damage: float = 0
@export var minimum_damage: float = 0
@export var maximum_damage: float = 0
@export var critical_hit_chance: float = 0.01
@export var critical_damage_multiplier: float = 1.5
@export var projectile_speed: float = 650
@export var attack_range: float = 250
@export var projectiles_max: int = 1
@export var range_tag: Tags.Range_Type
@export_range(0,2.0) var area: float = 1
@export var attack_speed: float = 100
@export var cooldown: float = 1.00
@export var duration: float = 1.00
@export var knockback: float = 0
@export var pierce: int = 0
@export var bounce: int = 0

@export_group("Images")
## This is what will be shown outside gameplay, this will be a simple static image of the object
@export var menu_image: Texture 
## This is the background image for the item to have as a back-drop.
@export var menu_image_backgroud: Texture

#region MORE IMAGES
##NOTE: There will also be the in-game images associated with the moves put in here.
#endregion
