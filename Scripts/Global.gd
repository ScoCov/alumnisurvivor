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
var STUDENT_ROSTER: Array[StudentResource]

#region NOTE:
## 
#endregion
var ENEMY_ROSTER: Array[EnemyResource]

#region NOTE:
## SELECTED_STUDENT is how we control which Student that is currently selected by
## the player to be used as the 'main character' or playable characer. This is used
## to create continuity across the menus and game.
#endregion
var SELECTED_STUDENT: StudentResource

var SELECTED_BESTY: StudentResource

var SELECTED_MAP: Map_Resource

#region NOTE:
##
#endregion
var ITEM_COLLECTION: Array[ItemResource]

#region NOTE:
##
#endregion
var ABILITIES: Array[Ability_Resource]

#region NOTE:
##
#endregion
var ATTRIBUTES: Array[AttributeResource]

#region Note:
##
#endregion
var MAPS: Array[Map_Resource]

#region Note:
##
#endregion
var load_mouths_array: Array[Variant]
var MOUTHS: Array[Texture]
var load_eyes_array: Array[Variant]
var EYES: Array[Texture]
var load_eyebrows_array: Array[Variant]
var EYEBROWS: Array[Texture]
var load_hair_array: Array[Variant]
var HAIR: Array[Texture]

#region NOTE:
## Tags will be applied to various objects, concepts, and anything we need to associated something
## with a group. These tags will be used eventually to help influence the drops that a player will see.
#endregion
enum student_tag {Player, Besty, UNASSIGNED}
enum group_tag {Athlete, Academic, Technologist, Trade_Skill, Socialite, Artist, Musician, None }
enum enemy_tag {Elite, Boss, Normal, Weak, Strong, Ranged}
enum attack_tag { Thrust, Swing, Slam, Wave, Beam, Single_Shot, Burst_Shot, Retaliation, Status_Effect }
enum ability_type {Attack, Defense, Support, Other, None}
enum range_tag {Melee, Area, Ranged}
enum damage_types { Blunt, Sharp, Ego, Sonic, Explosion, Toxic, Electric}

func _ready():
	@warning_ignore("static_called_on_instance")
	load_objects(Configuration.get_dir("student"), STUDENT_ROSTER)
	@warning_ignore("static_called_on_instance")
	load_objects(Configuration.get_dir("attribute"), ATTRIBUTES)
	@warning_ignore("static_called_on_instance")
	load_objects(Configuration.get_dir("enemy"), ENEMY_ROSTER)
	@warning_ignore("static_called_on_instance")
	load_objects(Configuration.get_dir("ability"), ABILITIES)
	@warning_ignore("static_called_on_instance")
	load_objects(Configuration.get_dir("item"), ITEM_COLLECTION)
	@warning_ignore("static_called_on_instance")
	load_objects(Configuration.get_dir("mouth"), load_mouths_array)
	@warning_ignore("static_called_on_instance")
	load_objects(Configuration.get_dir("eyes"), load_eyes_array)
	@warning_ignore("static_called_on_instance")
	load_objects(Configuration.get_dir("eyebrows"), load_eyebrows_array)
	@warning_ignore("static_called_on_instance")
	load_objects(Configuration.get_dir("hair"), load_hair_array)
	@warning_ignore("static_called_on_instance")
	load_objects(Configuration.get_dir("map"), MAPS)
	
	## Load in the Images
	load_textures(load_mouths_array, MOUTHS)
	load_textures(load_eyes_array, EYES)
	load_textures(load_eyebrows_array, EYEBROWS)
	load_textures(load_hair_array, HAIR)
	
	## Sorting Sections
	ATTRIBUTES.sort_custom(func(a,b): return a.ordinal < b.ordinal )
	STUDENT_ROSTER.sort_custom(func(a,b): return a.ordinal > b.ordinal )
	if len(STUDENT_ROSTER) > 1: ## If there's at least two students in the roster assign default students.
		SELECTED_STUDENT = STUDENT_ROSTER[0]
		SELECTED_BESTY = STUDENT_ROSTER[1]
		
func load_textures( array_to_load_from, variable_to_store_texture_set):
	for path_item in array_to_load_from: ## Directly loading in images doesn't work, we need to filter out
		var path = path_item.get_path()
		variable_to_store_texture_set.append(load(path))
	
func load_objects(_dir: String, variable: Variant):
	var files = DirAccess.get_files_at(_dir) ## The folder that has all the Students
	for file  in files: ## Iterate through the folder for each Student in it and add that student to the roster.
		if not ".import" in file: 
			variable.append(load(_dir + file))
