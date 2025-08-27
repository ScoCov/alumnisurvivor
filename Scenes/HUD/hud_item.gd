class_name HudItem
extends Control

@export var item_stack: ItemStack

func update():
	var msg 
	$Sprite2D.texture = item_stack.item.image
	$RichTextLabel.text = "[b]X%s[/b]" % item_stack.count
