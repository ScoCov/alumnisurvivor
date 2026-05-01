class_name Student_Resource
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

@export_category ("Visuals")
@export_color_no_alpha var background_color: Color 
@export_group("Head parts")
##HEAD VARIANTS
@export_enum("ROUND", "POINTED", "SQUARED") var HEAD_VARIANT = 0:
	set(val):
		head_variant = val
		HEAD_VARIANT = val
var head_variant: int = self.HEAD_VARIANT
@export_enum("DARKEST", "DARK", "LIGHTDARK", "LIGHT", "LIGHTEST") var HEAD_COLOR = 0:
	set(val):
		head_color = val
		HEAD_COLOR = val
var head_color: int = self.HEAD_COLOR

## EYE VARIANTS
@export_enum("DETERMINED", "HAPPY","FURY", "DOWNTURN", "SHARP" ) var EYE_VARIANT = 0:
	set(val):
		eyes_variant = val
		EYE_VARIANT = val
var eyes_variant: int = self.EYE_VARIANT
@export_enum("BROWN","PALE_BLUE", "HAZEL", "GREEN", "PALE_GREEN", "BLUE") var EYE_COLOR = 0:
	set(val):
		eyes_color = val
		EYE_COLOR = val
var eyes_color: int = self.EYE_COLOR
@export_enum("SWOOP", "LONG_STRAIGHT", "KYIONE") var HAIR_VARIANT = 0:
	set(val):
		hair_variant = val
		HAIR_VARIANT = val
var hair_variant: int = self.HAIR_VARIANT
@export_enum("BLONDE", "BROWN", "BLACK", "BRUNETTE", "RED") var HAIR_COLOR = 0:
	set(val):
		hair_color = val
		HAIR_COLOR = val
var hair_color: int = self.HAIR_COLOR 

@export_category("Tags")
@export_group("Flags")
@export var unlocked: bool = true
@export var hidden: bool = false
@export var student_tags: Tags.Group

func _to_string() -> String:
	return ("Student: %s " % [student_name] )
	
