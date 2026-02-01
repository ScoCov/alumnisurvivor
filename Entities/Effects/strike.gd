@tool
extends Node2D


@export var image: Texture:
	set(img):
		if img is Texture:
			image = img
			if particle:
				particle.texture = img

@export var emitting: bool = true:
	set(val):
		if particle:
			particle.emitting = val
		emitting = val

@onready var particle = $Particle


func _on_particle_finished():
	emitting = false
