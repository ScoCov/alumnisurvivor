class_name Student_Icon
extends Control


@export var student: StudentResource
var disabled = false:
	set(value):
		$"Disabled Filter".visible = value
		disabled = value
		$Control/HeadBeta2.modulate = Color(0,0,0, 255)
		mouse_default_cursor_shape = Control.CURSOR_ARROW
		
var currently_selected_student: bool = false:
	set(value):
		$"Selected as Student".visible = value
		
var select_student: bool = true
		
func _ready():
	$Control/HeadBeta2/Eyebrows01.texture = student.eyebrows
	$Control/HeadBeta2/Hair01.texture = student.hair
	$Control/HeadBeta2/Eyes01.texture = student.eyes
	$Control/HeadBeta2/Mouth01.texture = student.mouth
	tooltip_text = "%s" % student.student_name

func _on_focus_entered():
	#$LowMediumBeep.pitch_scale = randf_range(0.9, 1)
	#$LowMediumBeep.play(0)
	self.scale = Vector2(1.05,1.05)
	if select_student:
		Global.SELECTED_STUDENT = student
	else:
		Global.SELECTED_BESTY = student
	$"Focus Border".visible = true

func _on_focus_exited():
	$"Selected as Student".visible = false
	$"Focus Border".visible = false
	self.scale = Vector2(1,1)
