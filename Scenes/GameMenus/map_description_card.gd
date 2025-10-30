class_name Map_Description_Card
extends Control

@export var map: Map_Resource
@onready var description = $Panel/MarginContainer/Control/Control/MarginContainer/Description
@onready var sprite_2d = $Panel/MarginContainer/Control/Control/MarginContainer2/Control/Control/Sprite2D
@onready var map_name = $"Panel/MarginContainer/Control/Control/MarginContainer2/Control/Map Name"

@export var attempt_1: Control

func _ready():
	if map:
		attempt_1.text = map.display_name
		description.text = map.description
		
func _on_mouse_entered():
	grab_focus()
	$"Has Focus".visible = true
	scale = Vector2(1.01, 1.01)

func _on_mouse_exited():
	release_focus()
	$"Has Focus".visible = false
	scale = Vector2(1, 1)

func _on_button_pressed():
	Global.SELECTED_MAP = map
	get_tree().change_scene_to_file(map.scene_path)
