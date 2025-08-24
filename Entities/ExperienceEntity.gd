class_name ExperienceEntity
extends Node2D

## Assign the base level of XP this node will give. 
@export var xp: float = 1:
	set(value):
		xp = value
	get:
		var multiplier: float = 1
		match rank:
			"None":
				multiplier = 0
			"Low":
				multiplier = 1
			"Medium":
				multiplier = 1.5
			"High":
				multiplier = 2
		return xp
## Assign the rank of the node to determine what the xp's value scaling will result in.
@export_enum("None", "Low", "Medium", "High", "Unique" ) var rank: String = "Low"
