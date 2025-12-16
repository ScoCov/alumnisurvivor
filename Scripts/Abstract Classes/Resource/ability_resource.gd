class_name Ability_Resource
extends Resource


## Development Related Name
@export var ability_name: String
## Name to show the player
@export var display_name: String
## Name of file
@export var id: String
@export_multiline var description: String

@export_category("Adjustments") 
## Mutable Fields
@export var projectile_speed: float = 450
@export var attack_range: float = 500
@export var projectiles_max: int = 1
@export var range_tag: Global.range_tag
@export_range(0,5.0) var area: float = 1
@export var attack_speed: float = 0.5
@export var attack_speed_rate: float = 1.0
@export var cooldown_time: float = 1.00
@export var cooldown_rate: float = 1.00
@export var knockback: float = 0



@export_group("Images")
## This is what will be shown outside gameplay, this will be a simple static image of the object
@export var menu_image: Texture 
## This is the background image for the item to have as a back-drop.
@export var menu_image_backgroud: Texture

#region MORE IMAGES
##NOTE: There will also be the in-game images associated with the moves put in here.
#endregion
