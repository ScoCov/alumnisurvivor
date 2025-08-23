class_name AbilityResource
extends Resource


## Development Related Name
@export var ability_name: String
## Name to show the player
@export var display_name: String
## Name of file
@export var id: String
@export_multiline var description: String

@export_group("Tags")
## Global tags associating the ability with specific concepts through out the game.
@export var meta_tags: Array[Global.meta_tag]
@export var type_tags: Array[Global.meta_tag]

@export_group("Images")
## This is what will be shown outside gameplay, this will be a simple static image of the object
@export var menu_image: Texture 
## This is the background image for the item to have as a back-drop.
@export var menu_image_backgroud: Texture
#region MORE IMAGES
##NOTE: There will also be the in-game images associated with the moves put in here.
#endregion
