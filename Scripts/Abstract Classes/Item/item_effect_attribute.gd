class_name Item_Effect_Attribute
extends Item_Effect

@export var attribute: AttributeResource
@export var value: float
@export_enum( "Add", "Sub", "Multi", "Div") var modification = "Add"

func get_info_row() -> String:
	var sign_string:= ""
	match modification:
		"Add":
			sign_string = "+"
		"Sub": 
			sign_string = "-"
		"Multi":
			sign_string = "+%"
		"Div":
			sign_string = "-%"
	return "%s %s %s" % [attribute.name, sign_string, value]
