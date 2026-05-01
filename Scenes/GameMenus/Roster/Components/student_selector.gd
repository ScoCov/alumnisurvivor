class_name Roster_Student_Selector
extends Control

signal increment
signal decrement
signal student_selected
signal besty_selected
signal ready_pressed

const roster_icon_ps = preload("res://Scenes/GameMenus/Roster/Components/roster_icon.tscn")

@export var roster_cont: HBoxContainer
@export var scroll_cont: ScrollContainer
@export var mrgn_cont: MarginContainer 
@export var tween_value: float = 0.0
@export var focus_student: bool = true:
	set(value):
		if value:
			roster_cont.get_children().filter(func(child): return child.student == Global.SELECTED_BESTY)[0].grab_focus()
@export var audio_stream: AudioStreamPlayer2D	

var focused_student: Roster_Icon
var tween_duration: float = 0.25

@onready var inc_btn = $IncContainer/Inc_Btn
@onready var dec_btn = $DecContainer/Dec_Btn


## Carousel Video: https://www.youtube.com/watch?v=By1KxJ-LRsE

func _ready():
	grab_student(Global.SELECTED_STUDENT)
	for ricon: Roster_Icon in roster_cont.get_children():
		ricon.request_focus.connect(request_focus.bind(ricon))
	
func update_focused_student(student: Student_Resource, next: int = 0):
	var index = get_student_index() + next
	if index >= roster_cont.get_child_count() or index <= -1:
		index = get_student_index()
	if focused_student:
		highlight_icon(false)
	focused_student = roster_cont.get_child(index)

func grab_student(student: Student_Resource):
	update_focused_student(student)
	highlight_icon(true)
	
func play_noise():
	audio_stream.play(0)
	
func get_student_index()->int:
	var index = 0
	if focused_student != null:
		index = roster_cont.get_children().find_custom(func(child: Roster_Icon): return child == focused_student)
	return index
	
func find_student_index(student_resource: Student_Resource) -> int:
	return roster_cont.get_children().find_custom(func(ri): return ri.student == student_resource)
	
func _on_inc_btn_pressed():
	var scroll_value = tween_value + (get_scroll_distance())
	update_focused_student(focused_student.student, 1) 
	inc_btn.disabled = true
	play_noise()
	await tween_scroll(scroll_value)
	enable_buttons()
	#get_tree().create_timer(tween_duration).timeout.connect(func(): $IncContainer/Inc_Btn.disabled = false)
	increment.emit()

func _on_dec_btn_pressed():
	var scroll_value = tween_value - (get_scroll_distance() + 10)
	update_focused_student(focused_student.student, -1)
	dec_btn.disabled = true
	play_noise()
	await tween_scroll(scroll_value)
	enable_buttons()
	#get_tree().create_timer(tween_duration).timeout.connect(func(): $DecContainer/Dec_Btn.disabled = false)
	decrement.emit()
	
func get_scroll_distance():
	var icon_width = focused_student.size.x
	var space_between = roster_cont.get_theme_constant("seperation")
	var margin_spacers = mrgn_cont.get_theme_constant("margin_left")
	return icon_width + space_between + margin_spacers

func tween_scroll(scroll_value):
	tween_value = scroll_value
	var tween = get_tree().create_tween()
	tween.tween_property(scroll_cont, "scroll_horizontal", scroll_value,tween_duration)
	tween.connect("finished", highlight_icon.bind(true))
	await tween.finished
	if get_student_index() == 0:
		tween_value = 0

func enable_buttons():
	self.inc_btn.disabled = false
	self.dec_btn.disabled = false

func highlight_icon(is_visible: bool):
	focused_student.get_node("Focused").visible = is_visible
	focused_student.student_head.bob_head = is_visible
	var sNo: float = 1.1 if is_visible else 1.0
	focused_student.scale = Vector2(sNo,sNo)

func _on_select_student_pressed():
	student_selected.emit()

func _on_select_besty_pressed():
	besty_selected.emit()

func _on_ready_pressed():
	ready_pressed.emit()

func request_focus(roster_icon: Roster_Icon):
	var student_index: int = find_student_index(roster_icon.student)
	if student_index > -1:
		highlight_icon(false)
		var old_fs = focused_student
		focused_student = roster_cont.get_child(student_index) 
		var store_duration = tween_duration
		if roster_icon.position.x >= old_fs.position.x:
			if roster_icon.position.x / old_fs.position.x >= 0.5:
				tween_duration = 0.5
		else:
			if old_fs.position.x / roster_icon.position.x >= 0.5:
				tween_duration = 0.3
		tween_scroll(roster_icon.position.x +( 1 if roster_icon.position.x > old_fs.position.x else -1 * (roster_icon.size.x + roster_cont.get_theme_constant("seperation"))))
		tween_duration = store_duration
		play_noise()
		highlight_icon(true)
