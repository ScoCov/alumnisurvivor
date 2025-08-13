class_name BaseDamageStrategy
extends Resource


@export var base_damage: float
@export var source_of_damage: String





func deal_damage(entity: Variant):
	#If whatever you are dealing damage to has a 'Health' component to them - then do damage.
	if entity.has_node("Stats") and entity.get_node("Stats").has_node("Health"):
		# Do Damage
		pass
	pass
