@tool
extends Control

@export var game_ui: Game_Ui

func _ready():
	get_parent().connect("ready_signal", _on_Parent_ready,CONNECT_DEFERRED)

func _on_Parent_ready():
	game_ui = get_parent().game_ui
	#for child in $Margin/VBoxContainer.get_children():
		#var label_name: String = child.name ## Needs to be an Attribute.id formate
		#var list_of_attributes: bool = game_ui.player.items._attributes.has(label_name)
		#if list_of_attributes:
			#child.get_child(0).text = "%s" % [game_ui.player.items.get_attribute_bonus(label_name)]
			
func menu_update():
	_on_Parent_ready()
