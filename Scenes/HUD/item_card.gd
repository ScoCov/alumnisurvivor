class_name ItemCard
extends Control

@export var item: ItemResource:
	set(value):
		item = value
		update()
		
@export var ability: AbilityResource:
	set(value):
		ability = value
		update()

func _ready():
	pass

func update():
	if item: 
		$Label.text = item.item_name
		$Content/Image/Center/CenterPoint/Sprite2D.texture = item.image
		for child in $Content/Details/MarginContainer/Panel/MarginContainer/VBoxContainer.get_children():
			$Content/Details/MarginContainer/Panel/MarginContainer/VBoxContainer.remove_child(child)
			
		for bonus: ItemBonus in item.bonuses:
			if bonus == null: continue
			var new_label:= Label.new()
			new_label.text = "- %s + %s" % [bonus.attribute.name, str(bonus.start_value)] 
			$Content/Details/MarginContainer/Panel/MarginContainer/VBoxContainer.add_child(new_label)
	elif ability:
		$Label.text = ability.ability_name
		$Content/Image/Center/CenterPoint/Sprite2D.texture = ability.menu_image
			
		
func _on_button_pressed():
	grab_focus()

func _on_get_item_focus_entered():
	grab_focus()

func _on_get_item_focus_exited():
	release_focus()

func _on_focus_entered():
	$"Focus Border".visible = true

func _on_focus_exited():
	$"Focus Border".visible = false
