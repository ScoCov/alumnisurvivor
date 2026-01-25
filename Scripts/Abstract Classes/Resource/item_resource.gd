class_name Item_Resource
extends Resource


@export_category("Meta Data")
## Displayed to the user
@export var item_name: String
## Unique Idtentifier - meant to be used to find in the files
@export var item_id: String 
## Full description of what the item does and what buff/debuffs it will give.
@export_multiline var item_description: String = ""
## Quick information - WIP
@export var tool_tip: String = ""
## Is this Item available from the start of the game?
@export var unlocked: bool = false

@export_group("Tags")
@export var group_tags: Tags.Group
@export var rarity: Item_Rarity.rarity

@export_group("Images")
## This will be displayed when the player is given options to choose from. It will also show up
## in the collections log as the image a player can click on to see the detail information page.
@export var image: Texture = load("res://Assets/Image/Environment/grass_blades_01_64x64.png")
## This is planned to be able to accept a sheet of sprits, multiple sprite frames, or a single image.
@export_group("Count Limits")
## The maximum number that an Item can be stacked. If 0, there is no limit.
@export var max_count: int = 0
## If the item is supposed to by obtained once, enable this value.
@export var unique: bool = false
@export_category("Modifications")
@export var item_effects: Array[Item_Effect]
