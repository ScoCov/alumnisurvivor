class_name AttributeResource
extends Resource

## Name to be used and displayed
@export var name: String
## Unique Identifier
@export var id: String
## Display Order
@export var ordinal: int
## Used to help describe how the attribute effects game play
@export_multiline var description: String

## Some attributes should be limited in how modified they can be, this group
## allows the modifications of those limits.
@export_category("Values")
## Get the value stored
@export var value: float
## Set Minimum value for the attribute
@export var min_limit: float
## Set Maximum value for the attribute
@export var max_limit: float
## Enforce Minimum Limit
@export var min_limit_active: bool = false
## Enforce Maximum Limit
@export var max_limit_active: bool = false

@export_group("Identification")
## Set the image that will be displayed in menus
@export var icon: Texture
@export var color: Color
