class_name StudentResource
extends Resource

@export_category("Meta Data")
## Displayed everywhere the student will appear
@export var student_name: String = "" ## In-game_name
## Name used in filesystem. [Do not include the file extension.]
@export var file_name: String = ""
## Orginizational Position
@export var ordinal: int = 0

@export_category("Starting Ability")
### Each Student will start with an preassigned ability, ala Vampire Survivor. 
@export var starting_ability: Ability_Resource

@export_category("Besty Info")
@export_group("Stats")
##This section is loaded with the full gammit of attributes the student will have.
#@export var health: int = 10
@export var health: float = 10
@export var armor: float = 0
@export var attack_speed: float = 1.0
@export var bounce: float = 0
@export var cooldown: float = 0
@export var critical_chance: float = 0
@export var critical_damage: float = 0
@export var damage: float = 0
@export var duration: float = 0
@export var knockback: float = 0
@export var dodge: float = 0
@export var movement_speed: float = 1.0
@export var pierce: float = 0
@export var pickup_range: float = 0
@export var attack_range: float = 0
@export var collection_range: float = 0

@export_group("Besty Bonuses")
### Increases growth of given stat, when selected as a Besty.
@export var primary: AttributeResource
### Increases growth of given stat, when selected as a Besty.
@export var secondary: AttributeResource
### Reduces the growth of given stat, when selected as a Besty. 
@export var weakness: AttributeResource

@export_category("Images")
## Uses this texture in menus
@export var hair: Texture
@export var eyebrows: Texture
@export var eyes: Texture
@export var mouth: Texture

@export_category("Tags")
@export var unlocked: bool = true
## Unique Tags associated direactly with Students.
@export var student_tags: Array[Global.student_tag]

func _to_string() -> String:
	return ("Student: %s " % [student_name] )
	
