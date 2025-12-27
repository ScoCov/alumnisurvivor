class_name Item_Effect
extends Node

## Description 
## Item_Effect will be the individual effect that can be added to an item's effect.
## These will be able to either modify entity attributes or supply the entity with
## an ability of some sort (either a trigger, passive, automaticly_activated abiltiy)
###

@export_enum ("Mod_Attribute", "Add_Ability") var type: String


func modifiy_attribute(attribute: AttributeResource, callable: Callable):
	pass
	
func add_ability(ability: Ability_Entity, ):
	pass
