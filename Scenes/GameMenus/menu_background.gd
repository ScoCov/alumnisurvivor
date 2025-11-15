class_name Menu_Background
extends Control


func _ready():
	$AnimationPlayer.play("Background_Movement")
	
	
func _on_animation_player_animation_finished():
	$AnimationPlayer.play("Background_Movement")
