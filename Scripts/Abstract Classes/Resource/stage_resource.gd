class_name Stage_Resource
extends Resource

enum WIN_CONDITION {SURVIVE, BOSS, KILL_COUNT, EXTRACTION}

## Used to organize the maps but also to control enemy strength.
@export_range(1,20) var stage_number: int = 1
@export var stage_type: WIN_CONDITION = 0
## Stage Name is used to display to the player the name of the location.
@export var stage_name: String = "Place Holder"
## Used in the School Map, when selected, it will describe the map or provide
## details about the given stage.
@export_multiline var description = "Blah Blah"

@export_group("Icon")
## Used in the School Map, when selected, it should give a simple building or 
## notable feature for the given stage. eg. School Entrance being the front of 
## the school building.
@export var icon: Texture

@export_group("Time Limit")
## Time Limit will control stage time length. The unit will be dedicated to 1 second intervals. 
## If the time_limit is set to <0 the time_limit shall be, in-effect, infinite.
@export var time_limit: float = 120 

## Give the types of enemies that are to be spawned.
## The Enemy Spawner will sort them out according to their individual power levels. The lists are simply,
## each type of enemy that is to appear in the given difficulty mode of that stage.
@export_category("Enemy Lists")
@export_subgroup("Normal Enemies")
## Assign Enemies that will appear in NORMAL difficulty.
@export var normal_enemies: Array[EnemyResource]
## Assign Enemies that will appear in DIFFICULT difficulty.
@export_subgroup("Diffficult Enemies")
@export var difficulty_enemies: Array[EnemyResource]
@export_subgroup("Hard Enemies")
## Assign Enemies that will appear in HARD difficulty.
@export var hard_enemies: Array[EnemyResource]
@export_subgroup("Very Hard Enemies")
## Assign Enemies that will appear in VERY HARD difficulty.
@export var very_hard_enemies: Array[EnemyResource]
@export_subgroup("Impossible Enemies") 
## Assign Enemies that will appear in IMPOSSIBLE difficulty.
@export var impossible_enemies: Array[EnemyResource]
## Assign Enemies that will appear in LEGENDARY difficulty.
@export_subgroup("Legendary Enemies")
@export var legendary_enemies: Array[EnemyResource]
