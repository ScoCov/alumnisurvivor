class_name AbilityResource
extends Resource


## Development Related Name
@export var ability_name: String
## Name to show the player
@export var display_name: String
## Name of file
@export var id: String
@export_multiline var description: String

##This section is loaded with the full gammit of attributes an ability can have.
@export_group("Stats")
var armor: float = 0
var attack_speed: float = 0
var bounce: float = 0
var cooldown: float = 0
var critical_chance: float = 0
var critical_damage_multiplier: float = 0
var damage: float = 0
var duration: float = 0
var knockback: float = 0
var movement_speed: float = 0
var pierce: float = 0
var pickup_range: float = 0



@export_group("Images")
## This is what will be shown outside gameplay, this will be a simple static image of the object
@export var menu_image: Texture 
## This is the background image for the item to have as a back-drop.
@export var menu_image_backgroud: Texture

#region MORE IMAGES
##NOTE: There will also be the in-game images associated with the moves put in here.
#endregion
