extends Control


@export var player: StudentEntity





func update():
	for attribute: Component in player.get_node("Composition").get_children():
		var attribute_desired = $MarginContainer/Control/Content/VBoxContainer.get_children().filter( func(label): 
			return attribute.name == label.name)
		if attribute_desired:
			attribute_desired = attribute_desired[0]
			attribute_desired.get_child(0).text = " %s + %s = %s" % [str(attribute.base_value), str(attribute.mod_value), str(attribute.value)]
