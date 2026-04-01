class_name StudentResource
extends Resource

@export_category("Meta Data")
## Displayed everywhere the student will appear
@export var student_name: String = "" ## In-game_name
## Name used in filesystem. [Do not include the file extension.] This is also the student_id
@export var file_name: String = ""
## Orginizational Position
@export var ordinal: int = 0
### Each Student will start with an preassigned ability, ala Vampire Survivor. 
@export var starting_ability: Ability_Resource
@export_category("Bonuses")
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
@export var student_tags: Tags.Group
## Unique Tags associated direactly with Students.
#@export var student_tags: Array[Global.student_tag]

func _to_string() -> String:
	return ("Student: %s " % [student_name] )
	
