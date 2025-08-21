class_name Item
extends Resource


@export_category("Meta Data")
## Displayed to the user
@export var item_name: String
## Unique Idtentifier
@export var item_id: String 
## Full description of what the item does and what buff/debuffs it will give.
@export_multiline var item_description: String 
## Quick information
@export var tool_tip: String
@export var unlocked: bool = false

@export_group("Tags")
@export var meta_tags: Array[Global.meta_tag]
@export var type_tags: Array[Global.type_tag]

@export_group("Images")
## This will be displayed when the player is given options to choose from. It will also show up
## in the collections log as the image a player can click on to see the detail information page.
@export var image: Texture
## This is planned to be able to accept a sheet of sprits, multiple sprite frames, or a single image.
@export var in_game_image: Texture
@export_group("Count")
## The maximum number that an Item can be stacked. If 0, there is no limit.
@export var max_count: int = 0
## If the item is supposed to by obtained once, enable this value.
@export var unique: bool = false
@export_category("Modifications")
@export var bonuses: Array[ItemBonus]



