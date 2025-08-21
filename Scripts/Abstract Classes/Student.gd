class_name Student
extends Resource

@export_category("Meta Data")
## Displayed everywhere the student will appear
@export var student_name: String = "STUDENT_NAME" ## In-game_name
@export var title_or_nickname: String = ""
## Increases growth of given stat
@export_enum("Hitpoints", "Damage", "Movement Speed", "Cooldown", "Duration", "Critical Chance") 
var primary_skill: String 
## Increases growth of given stat
@export_enum("Hitpoints", "Damage", "Movement Speed", "Cooldown", "Duration", "Critical Chance") 
var secondary_skill: String
## Reduces the growth of given stat 
@export_enum("Hitpoints", "Damage", "Movement Speed", "Cooldown", "Duration", "Critical Chance") 
var weakness_skill: String
## Each Student will start with an preassigned ability, ala Vampire Survivor. 
@export var starting_ability: String
@export_group("Tags")
@export var unlocked: bool = true
@export var student_tags: Array[Global.student_tag]
@export var meta_tags: Array[Global.meta_tag]
@export var combat_tags: Array[Global.combat_tag]

@export_group("Images")
## Uses this texture in menus
@export var icon: Texture = preload("res://Resources/Image/Temp/Greyknight_Icon.png")
## In-game sprite - This should be multiple frames later for now, a signle image will be okay.
@export var doll: Texture = preload("res://Resources/Image/Temp/Greyknight_Doll.png")
## Detailed Image showed during dialogue
@export var avatar: Texture = preload("res://Resources/Image/Temp/Greyknight_Portrait.png")

func _ready():
	pass
	
func _to_string() -> String:
	return ("Student: %s " % [student_name] )
