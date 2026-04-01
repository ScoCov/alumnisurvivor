class_name Status_Burn
extends Status_Effect_Entity


func _process(_delta):
	$Label.text = "Burn Stack Count: %s" % stack_count

func _ready():
	pass

func _on_expires():
	pass

func _on_tick():
	entity.health.apply_dot_damage(1, self)

func _on_initial_infection():
	pass
