class_name Ability_Resource
extends Resource

const LEVEL_LIMIT: int = 4

## Development Related Name
@export var ability_name: String
## Name to show the player
@export var display_name: String
## Name of file
@export var id: String
@export_multiline var description: String

@export_category("Stats") 
@export var projectiles_max: int = 1
@export var range_tag: Tags.Range_Type
## Mutable Fields
@export_group("Stats based on levels")
@export var base_damage: Array[float] = [0,0,0,0]
@export var min_damage: Array[float] = [0,0,0,0]
@export var max_damage: Array[float] = [0,0,0,0]
@export var critical_hit: Array[float] = [0,0,0,0]
@export var critical_damage: Array[float] = [0,0,0,0]
@export var projectile_speed: Array[float] = [0,0,0,0]
@export var detection_range: Array[float] = [0,0,0,0]
@export_range(50,250) var area: Array[float] = [0,0,0,0]
@export var attack_speed: Array[float] = [0,0,0,0]
@export var cooldown: Array[float] = [0,0,0,0]
@export var duration: Array[float] = [0,0,0,0]
@export var knockback: Array[float] = [0,0,0,0]
@export var pierce: Array[int] = [0,0,0,0]
@export var bounce: Array[int] = [0,0,0,0]

@export_category("Images")
## This is what will be shown outside gameplay, this will be a simple static image of the object
@export var menu_image: Texture 
