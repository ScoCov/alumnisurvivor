class_name EnemyBase
extends Resource


@export var name: String
@export var id: String

@export_group("Tags")
@export var tags: Array[Global.tag]


@export_group("Images")
@export var image: Texture

@export_enum("None", "Low", "Medium", "High", "Special") var experience_group: String
