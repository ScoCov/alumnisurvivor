class_name HudItem
extends Control

const self_modulate_value:= Color(1.0, 1.0, 1.0, 0.498)

@export var item_stack: ItemStack

func _ready():
	update()

func _update_tool_tip():
	$"Control/Item Name".text = item_stack.item.item_name
	var message = ""
	for item_bonus: ItemBonus in item_stack.item.bonuses:
			var next_line: String = "" if message == "" else message + "\n"
			var initial_value = item_bonus.initial_value
			var mod_value = item_bonus.level_value *( item_stack.count -1)
			message = ("%s%s: [color=green]%s[/color] (+%s) = %s" % 
				[next_line, item_bonus.attribute.name, initial_value, 
				mod_value, initial_value + mod_value])
	$Control/Details/ToolTip.text = message
	
func update():
	if item_stack:
		_update_tool_tip()
		$Sprite2D.texture = item_stack.item.image
		$RichTextLabel.text = "[b]X%s[/b]" % item_stack.count 

func _on_area_2d_mouse_entered() -> void:
	$Control.visible =  true
	$Sprite2D.self_modulate = Color(1,1,1,1)
	$RichTextLabel.self_modulate = Color(1,1,1,1)
	

func _on_area_2d_mouse_exited() -> void:
	$Control.visible =  false
	$Sprite2D.self_modulate = self_modulate_value
	$RichTextLabel.self_modulate = self_modulate_value
