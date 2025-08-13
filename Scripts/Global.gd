extends Node

#region DESCRIPTION
## Global Script is to be active the entire time the game is running. The point for this
## is so that there is always a single location to point to universal, or 'global',
## data values. Use this script page to define constants, shared data, and to control the currently
## selected students the player will use in the next game.
##
## We assign the Global.gd script to the 'Auto-load' feature of Godot in the 'Project' option of
## the Godot Engine's ribbon menu on top. This script will be always present and
## to access it all you will need to do is treat it like an object with the 'Global' syntax.
##
## EXAMPLE:
## To use SELECTED_STUDENT variable/field from this global script in another one
## you simply use the 'Global.SELECTED_STUDENT' syntax. You can assign this to a
## variable of the type "Student," as well; var _student: Student = Global.SELECTED_STUDENT.
##
## NOTE: All variables in this folder to be used will be upper case notation, as though
## they are to be treated as a CONSTANT - besides the SELECTED_STUDENT and SELECTED_BESTY
## no outside influence should ever alter the variables inside this script.
#endregion

#region NOTE:
## STUDENT_ROSTER is used to collect all the students that have been created,
## so that the number, and the Students themselves, don't have to be hard-coded in or manually discovered
## down-the-line.
#endregion
var STUDENT_ROSTER: Array[Student]

#region NOTE:
## SELECTED_STUDENT is how we control which Student that is currently selected by
## the player to be used as the 'main character' or playable characer. This is used
## to create continuity across the menus and game.
#endregion
var SELECTED_STUDENT: Student

#region NOTE:
## SELECTED_BESTY is the same thing as SELECTED_STUDENT but for the Besty.
## By having these 'SELECTED_' variables we are able to have the Student and Besty
## talk to eachother throughout the menus. And as well as know who will be playing
## next.
#endregion
var SELECTED_BESTY: Student

#region NOTE:
##
#endregion
var ITEM_COLLECTION: Array[Item]

#region NOTE:
##
#endregion
var ABILITIES: Array[Ability]

#region NOTE:
##
#endregion
var ATTRIBUTES: Array[Attribute]

var _CONFIGURATION:= ConfigFile.new()


#region NOTE:
## Tags will be applied to various objects, concepts, and anything we need to associated something
## with a group. These tags will be used eventually to help influence the drops that a player will see.
## Example: If a Player has a "Drama" tag, they are likely to see to Items or Abilities that share the
## "Drama" tag.
#endregion
enum tag {Elite, Boss, Normal, Ranged, Tank, Player, Besty, Enemy, Band, Drama, Sports, Nerd, Popular, Outcast, Debug}

func _init() -> void:
	_CONFIGURATION.load("res://env.cfg")

## Use the _ready function to initialize the STUDENT_ROSTER and any other collection of data.
func _ready():
	#var student_files = DirAccess.get_files_at("res://Resources/Data/Students/") ## The folder that has all the Students
	#load_objects("res://Resources/Data/Students/", STUDENT_ROSTER)
	load_objects(_CONFIGURATION.get_value("files", "student_resrouce_directory"), STUDENT_ROSTER)
	load_objects("res://Resources/Data/Attributes/", ATTRIBUTES)
	if len(STUDENT_ROSTER) > 1: ## If there's at least two students in the roster assign default students.
		SELECTED_STUDENT = STUDENT_ROSTER[0]
		SELECTED_BESTY = STUDENT_ROSTER[1]
	
	
func load_objects(_dir: String, variable: Variant):
	var files = DirAccess.get_files_at(_dir) ## The folder that has all the Students
	for file  in files: ## Iterate through the folder for each Student in it and add that student to the roster.
		variable.append(load(_dir + file))


## Use this method, instead of calling SELECTED_[Student/Besty] directly to have
## some validation controls.
func change_selected(player_or_besty: String, _student: Student):
	assert(player_or_besty.to_lower() in ["player", "besty"],
	"change_selected must have a value of %s or %s" % ["player", "besty"])
	match player_or_besty:
		"player":
			if SELECTED_BESTY in [_student]:
				## If Student being assigned is also current Besty, assign current
				## Student as the new Besty.
				SELECTED_BESTY = SELECTED_STUDENT
			SELECTED_STUDENT = _student
		"besty":
			if SELECTED_STUDENT in [_student]:
				## If Student being assigned is also current Student, assign current
				## Besty as the new Student
				SELECTED_STUDENT = SELECTED_BESTY
			SELECTED_BESTY = _student
