class_name StudentResource
extends Resource

@export_category("Meta Data")
## Displayed everywhere the student will appear
@export var student_name: String = "STUDENT_NAME" ## In-game_name
## Name used in filesystem
@export var id: String = ""
## TODO - Figure out a way not not require this manual insert.
@export var scene_path: String
### Increases growth of given stat
@export var primary: AttributeResource
### Increases growth of given stat
@export var secondary: AttributeResource
### Reduces the growth of given stat 
@export var weakness: AttributeResource
### Each Student will start with an preassigned ability, ala Vampire Survivor. 
@export var starting_ability: AbilityResource
@export_category("Images")
## Uses this texture in menus
@export var icon: Texture = preload("res://Resources/Image/Temp/Greyknight_Icon.png")
@export var doll: Texture = preload("res://Resources/Image/Temp/Greyknight_Doll.png")
@export_category("Tags")
@export var unlocked: bool = true
## Unique Tags associated direactly with Students.
@export var student_tags: Array[Global.student_tag]
## Unique Tags associated with information about the entity itself.
@export var meta_tags: Array[Global.meta_tag]
## Used to determine in-game combat related effects and the outcome of those effects.
@export var combat_tags: Array[Global.combat_tag]


func _ready():
	pass
	
func _to_string() -> String:
	return ("Student: %s " % [student_name] )
