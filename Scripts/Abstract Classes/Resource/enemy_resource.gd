class_name EnemyResource
extends Resource

@export_category("Information")
@export var name: String
@export var file_name: String
@export var enemy_scene_path: String
@export var power_level: float = 0
@export var xp_per_power: float = 0
@export_group("Description")
@export_multiline var description: String
@export_group("Images")
@export var looks_at_target: bool = false
@export var image_variants: Array[Texture]
@export_group("Tags")
#@export var enemy: Array[Global.enemy_tag] = [Global.enemy_tag.Normal]
#@export var group: Array[Global.group_tag] = [Global.group_tag.None]
#@export var damage_type: Array[Global.damage_types] = [Global.damage_types.Blunt]
@export_group("Other")

@export_category("Movement")
## The way the enemy will move in game. 
#@export var move_style: EnemyMovementStrategy.type
## Default Movement Speed = 75
@export var movement_speed: float = 75
## When using a Wander-Type of Movement, the enemy will redirect it's self [wander_timer]-seconds.
@export var wander_timer: float = 4.0
## When using an Avoid-Type of Movement, the enemy will not move further than this maximum.
@export var furthest_distance: float = 0.0
## When using an Avoid-Type of Movement, the enemy will try to move away from the player if distance is below this value.
@export var closest_distance: float = 0.0

@export_category("Health")
@export var maximum_health: int = 5
@export var armor: int = 0
@export var dodge: float = 0.0

@export_category("Damage")
## If the player touches the enemy, does it deal damage to them?
@export var touch_damage: bool = true
@export var damage: float = 0.0
@export var critical_chance: float = 0.0
@export var critical_damage: float = 0.0

@export_category("Multipliers")
@export var cooldown: float = 1.0
@export var attack_speed: float = 1.0
@export var duration: float = 1.0

@export_category("Ranged Modifiers")
@export var projectiles: int = 0
@export var pierce: int = 0
@export var bounce: int = 0
