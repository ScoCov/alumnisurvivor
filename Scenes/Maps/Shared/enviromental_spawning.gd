extends Node2D

const grass_sprite_texture:= preload("res://Assets/Image/Environment/grass_blades_01_32x32.png")
const large_grass_packed_scene:= preload("res://Entities/Enviromental/large_grass.tscn")

@export var spawn_area: Vector2

func _ready():
	for grass_sprite in 75:
		var new_grass := large_grass_packed_scene.instantiate()
		new_grass.position = Vector2(randf_range(0, spawn_area.x), randf_range(0, spawn_area.y))
		new_grass.set_instance_shader_parameter("time_offset", randf_range(-1.0, 1.0))
		add_child(new_grass)
