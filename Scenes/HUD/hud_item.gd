class_name HudItem
extends Control

const self_modulate_value:= Color(1.0, 1.0, 1.0, 0.498)

@export var item_stack: ItemStack

func _ready():
	update()

func _update_tool_tip():
	$"Control/Item Name".text = item_stack.item.item_name
	$Control/Details/ToolTip.text = item_stack.item.tool_tip
	
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
