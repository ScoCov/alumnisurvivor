extends Node



var STUDENT_ROSTER: Array[Student_Resource]

var ENEMY_ROSTER: Array[EnemyResource]

var ITEM_COLLECTION: Array[Item_Resource]

var ABILITIES: Array[Ability_Resource]

var ATTRIBUTES: Array[AttributeResource]

var MAPS: Array[Map_Resource]

var STATUS_EFFECTS: Array[Status_Effect_Resource]

var SELECTED_STUDENT: Student_Resource

var SELECTED_BESTY: Student_Resource

var SELECTED_MAP: Map_Resource

func _ready():
	load_objects(Loader.get_dir("student"), STUDENT_ROSTER)
	load_objects(Loader.get_dir("attribute"), ATTRIBUTES)
	load_objects(Loader.get_dir("enemy"), ENEMY_ROSTER)
	load_objects(Loader.get_dir("ability"), ABILITIES)
	load_objects(Loader.get_dir("item"), ITEM_COLLECTION)
	load_objects(Loader.get_dir("map"), MAPS)
	load_objects(Loader.get_dir("status_effects"), STATUS_EFFECTS)
	
	# Sorting Sections
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
			
func select_student_as_primary(student: Student_Resource) -> bool:
	var character_swap: bool = false
	if SELECTED_BESTY == student:
		var temp_student: Student_Resource = SELECTED_STUDENT
		SELECTED_STUDENT = SELECTED_BESTY
		SELECTED_BESTY = temp_student
		character_swap = true
	elif SELECTED_STUDENT == student:
		pass
	else:
		SELECTED_STUDENT = student
	return character_swap
	
func select_student_as_secondary(student: Student_Resource)-> bool:
	var character_swap: bool = false
	if SELECTED_STUDENT == student:
		var temp_student: Student_Resource = SELECTED_BESTY
		SELECTED_BESTY = SELECTED_STUDENT
		SELECTED_STUDENT = temp_student
		character_swap = true
	elif SELECTED_BESTY == student:
		pass
	else:
		SELECTED_BESTY = student
	return character_swap
