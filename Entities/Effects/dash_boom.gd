@tool
extends Node2D


@export var direction: Vector3:
	set(dir):
		direction = dir
		if trail:
			(trail.process_material as ParticleProcessMaterial).direction = dir
		
@export var emitting: bool = false:
	set(value):
		emitting = value
		if boom and trail:
			boom.emitting = value
			trail.emitting = value
		
@onready var boom = $Boom
@onready var trail = $Trail

func _ready():
	boom.emitting = false
	trail.emitting = false
