class_name ItemBonus
extends Resource

## Give the name of the attribute you want to modify.
## TODO: Say SpecialEffect (may change) to add odd abilities, instead of just stat modifications
@export var attribute: Attribute
## This is the value given when the player has a single stack of this item.
@export var start_value: float
## This is the value that grows with the number of items in a stack
@export var growth_modifier: float
## We will need an alternative "Strategy" for the non-attribute effects.

