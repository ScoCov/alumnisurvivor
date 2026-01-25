extends Node



var STUDENT_ROSTER: Array[StudentResource]

var ENEMY_ROSTER: Array[EnemyResource]

var ITEM_COLLECTION: Array[Item_Resource]

var ABILITIES: Array[Ability_Resource]

var ATTRIBUTES: Array[AttributeResource]

var MAPS: Array[Map_Resource]

var STATUS_EFFECTS: Array[Status_Effect_Resource]

var SELECTED_STUDENT: StudentResource

var SELECTED_BESTY: StudentResource

var SELECTED_MAP: Map_Resource

var load_mouths_array: Array[Variant]
var MOUTHS: Array[Texture]
var load_eyes_array: Array[Variant]
var EYES: Array[Texture]
var load_eyebrows_array: Array[Variant]
var EYEBROWS: Array[Texture]
var load_hair_array: Array[Variant]
var HAIR: Array[Texture]

func _ready():
	var config = Config.new()
	load_objects(config.get_dir("student"), STUDENT_ROSTER)
	load_objects(config.get_dir("attribute"), ATTRIBUTES)
	load_objects(config.get_dir("enemy"), ENEMY_ROSTER)
	load_objects(config.get_dir("ability"), ABILITIES)
	load_objects(config.get_dir("item"), ITEM_COLLECTION)
	load_objects(config.get_dir("mouth"), load_mouths_array)
	load_objects(config.get_dir("eyes"), load_eyes_array)
	load_objects(config.get_dir("eyebrows"), load_eyebrows_array)
	load_objects(config.get_dir("hair"), load_hair_array)
	load_objects(config.get_dir("map"), MAPS)
	load_objects(config.get_dir("status_effects"), STATUS_EFFECTS)
	
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
