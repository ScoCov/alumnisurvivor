extends Control


@export var player: StudentEntity


func update():
	for attribute: Component in player.get_node("Composition").get_children():
		var attribute_desired = $MarginContainer/Control/Content/VBoxContainer.get_children().filter( func(label): 
			return attribute.name == label.name)
		if attribute_desired:
			attribute_desired = attribute_desired[0]
			var color_string = "white"
			if attribute.value < attribute.base_value:
				color_string = "red"
			elif  attribute.value > attribute.base_value:
				color_string = "green"
			attribute_desired.get_child(0).text = "[color=\"%s\"]%s[/color]" % [color_string, str(attribute.value)]
			if attribute_desired.name == "MovementSpeed":
				attribute_desired.get_child(0).text += " | %s" % str(player.DEFAULT_MOVEMENT_SPEED + (player.DEFAULT_MOVEMENT_SPEED * attribute.value))
