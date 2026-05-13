class_name Conductor
extends Node

const SAVE_FILE_PATH: String =  "res://Saves/current_run.cfg"
const ITEMS_CONTAINER: Script = preload("res://Scripts/Abstract Classes/Item/item_container.gd")
const EXPERIENCE_MANAGER: Script = preload("res://Entities/Components/Managers/experience_manager.gd")

## Strings to use during save/load
const SECTION: String = "Current Run"
const ITEMS: String = "items"
const EXPERIENCE: String = "experience"

## Nodes that will have scripts attached to them. 
var items: Item_Container
var experience: Experience_Manager
var game_logic: Game_Local

## Current run details
var current_difficulty: Difficulty.MODE = Difficulty.MODE.NORMAL
var current_player_entity: Player_Entity
var current_stage_number: int = 0
var run_saved: bool = false

## Items Store Information
var credits: int = 0
var items_purchased: int = 0
var student_swapped: int = 0

## Abilities Store Information 
var abilities_purchased: int = 0
var abilities_upgraded: int = 0
var level_up_points: int = 0

## Global Upgrade Currency (Move to Global Script?)
var monster_parts: int = 0

## Save Details
var save_file:= ConfigFile.new()

## Description
## This is a global script to be used per run. This will control the data that needs to be carried
## over from stage to stage, as well as any of the appropriate data to save when interrupting a 
## run by closing the game or going back to the main menu.
## 
## This should allow us to save student entity, the various currencies gained, and damage numbers.
	

func _init():
	_init_nodes()
	if is_save_current(): ## If there is a save to use, use it. 
		load_data()
	
## Resets all data to 0. 
func clear():
	_init_nodes()
	current_stage_number = 0
	
func _init_nodes():
	var new_items:= Node.new()
	new_items.set_script(ITEMS_CONTAINER)
	items = new_items
	var new_experience:= Node.new()
	new_experience.set_script(EXPERIENCE_MANAGER)
	experience = new_experience

## Store run into a config file.
func save_data(active: bool = false):
	save_file.set_value(SECTION, "active", active)
	save_file.set_value(SECTION, "current_stage", current_stage_number)
	save_file.set_value(SECTION, ITEMS, items)
	save_file.set_value(SECTION, EXPERIENCE, experience)
	save_file.set_value(SECTION, "monster_parts", monster_parts)
	save_file.save(SAVE_FILE_PATH)

## Load data from the storage config file.
func load_data():
	save_file.load(SAVE_FILE_PATH)
	current_stage_number = save_file.get_value(SECTION, "current_stage")
	items = save_file.get_value(SECTION, ITEMS)
	experience = save_file.get_value(SECTION, EXPERIENCE)
	monster_parts = save_file.get_value(SECTION, "monster_parts")

func is_save_current()-> bool:
	save_file.load(SAVE_FILE_PATH)
	var result = save_file.get_value(SECTION, "active")
	if result == null:
		result = false
	return result
