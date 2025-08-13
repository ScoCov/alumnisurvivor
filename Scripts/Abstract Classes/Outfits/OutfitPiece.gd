class_name OutfitPiece
extends Resource

## Choose the body part in which the outfit pice will adhere to.
@export_enum("HEAD", "CHEST", "LEGS", "FEET", "ACCESORRY_01","ACCESSORY_02") var body_part: String
## Displayed to the user.
@export var name: String
## Unique Identifier, for searching purposes
@export var id: String
## This will be displayed as the icon when selecting the item in the outfit menu
@export var icon: Texture = load("res://Resources/Image/Temp/Outfit_icon.png")
## The actual clothing piece that will be present on the doll
@export var doll_clothing: Texture
