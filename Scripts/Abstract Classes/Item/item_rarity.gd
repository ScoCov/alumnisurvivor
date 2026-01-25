class_name Item_Rarity
extends Node

enum rarity {Common, Uncommon, Rare, Legendary}
const _spawn_chance: Array[float] = [1, 0.15,.025,.005]
const _colors: Array[Color] = [Color.GHOST_WHITE, Color.GREEN, Color.BLUE, Color.PURPLE]

static func get_spawn_chance(_index :rarity) -> float:
	return _spawn_chance[_index]

static func get_rarity_color (_index :rarity) -> Color:
	return _colors[_index]
