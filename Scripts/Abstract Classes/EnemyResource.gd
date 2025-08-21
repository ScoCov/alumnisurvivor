class_name EnemyResource
extends Resource

@export_category("Information")
@export var name: String
@export var id: String
@export_multiline var description: String

@export_category("Combat")



@export_group("Tags")
@export var meta_tags: Array[Global.meta_tag]
@export var combat_tags: Array[Global.combat_tag]

@export_group("Images")
@export var image: Texture

@export_enum("None", "Low", "Medium", "High", "Special") var experience_group: String
