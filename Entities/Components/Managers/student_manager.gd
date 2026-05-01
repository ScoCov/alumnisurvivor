class_name Student_Manager
extends Node

signal student_swap

enum BONUS {PRIMARY, SECONDARY, WEAKNESS}  

const PRIMARY_BONUS: float = 0.20
const SECONDARY_BONUS: float = 0.10
const WEAKNESS_BONUS: float = -0.10

enum _student_options {STUDENT, BESTY}

@export var starter_student: _student_options:
	set(value):
		_current_student = value
@export var swap_timer: Timer

var _current_student: _student_options:
	set(value):
		swap_students(value)
		_current_student = value

## This class variable is to be used as the currently active student between primary and besty student.
@export var active_student: Student_Resource = Global.SELECTED_STUDENT
var support_student: Student_Resource = Global.SELECTED_BESTY

## Primary Student is always the "SELECTED_STUDENT" from Global
var primary_student: Student_Resource:
	get():
		return Global.SELECTED_STUDENT
## Besty Student is always the "SELECTED_BESTY" from Global
var besty_student: Student_Resource:
	get():
		return Global.SELECTED_BESTY

var _can_swap: bool = true

func _input(event):
	if event.is_action_pressed("swap_besty"):
		if _current_student == _student_options.STUDENT:
			_current_student = _student_options.BESTY
		else:
			_current_student = _student_options.STUDENT
			
func _ready():
	swap_timer.connect("timeout", reset_swap)

func reset_swap():
	_can_swap = true

func swap_students(student: _student_options):
	if !_can_swap:
		return
	if student == _student_options.STUDENT:
		active_student = primary_student
		support_student = besty_student
	if student == _student_options.BESTY:
		active_student = besty_student
		support_student = primary_student
	if swap_timer.is_stopped():
		_can_swap = false
		swap_timer.start()
		student_swap.emit()

## This function is used to obtain a percentage value that should be applied on top of the 
## base value of an attribute and the items bonuses combined. 
## Example: If player is using movement_speed is 100 and they have items that increase that by 20%,
## giving the player 120 movement speed, the bonus given by this will be applied to that total sum.
## If the bonus given by this function is "0.15", the resulting speed will now be 138
## Usage: total_value = (base_value + item_value) * (1 + get_bonus_by_attribute(attribute_id))
func get_bonus_by_attribute(attribute_id: String) -> float:
	var total = 0
	if active_student.primary.id == attribute_id:
		total += PRIMARY_BONUS
	if active_student.secondary.id == attribute_id:
		total += SECONDARY_BONUS
	if active_student.weakness.id == attribute_id:
		total += WEAKNESS_BONUS
		
	## Support Student's Attributes are added at half value, except Weakness which is always full strength.
	if support_student.primary.id == attribute_id:
		total += PRIMARY_BONUS/2
	if support_student.secondary.id == attribute_id:
		total += SECONDARY_BONUS/2
	if support_student.weakness.id == attribute_id: ## always full strength
		total += WEAKNESS_BONUS
	return total
