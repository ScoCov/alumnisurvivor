class_name EnemyAngryStudent
extends EnemyEntity


func _process(_delta):
	$Marker2D.look_at(player.get_parent().position + player.position if player else get_global_mouse_position())
