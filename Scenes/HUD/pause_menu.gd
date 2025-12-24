class_name Pause_Menu
extends Control

@export var game_ui: Game_Ui
@export var rendering_node: Node2D

func _unhandled_input(event):
	if event is InputEventKey and (event as InputEventKey).is_action_released("pause"):
		_pause_screen_toggle()

func _on_resume_pressed():
	_pause_screen_toggle()

func _on_quit_pressed():
	get_tree().quit()

func _pause_screen_toggle():
	get_tree().paused = !get_tree().paused
	_change_visibility()

func _change_visibility() -> void:
	self.visible = get_tree().paused
	game_ui.visible = !self.visible
	rendering_node.visible = !self.visible
	if self.visible:
		$Panel/MarginContainer/VBoxContainer/Resume.grab_focus()
