extends Control
class_name SmartPhone


##Just adding a quick change
var current_student_page: StudentPage

func _ready():
	current_student_page = $Pages.get_children().filter(func(student_page): 
		return student_page is StudentPage and student_page.visible)[0]


## Go from the LandingPage to the Student_Pages. This is done by
## making the LandingPage Node insivible and making the Pages node visible, 
## which will have the currently selected player as the visible page.
func _on_student_profile_pressed():
	swap_pages($LandingPage, $Pages)


## Returning to the landing page. It does this by reversing the visibility changes.
func _on_home_pressed():
	swap_pages($Pages,$LandingPage)
	
## Change the profile currently being view to a Student who is a lower index. If the Student
## is the first one of the array, then roll over to the last Student.
func _on_back_pressed():
	change_student_page(-1)

## Change the profile currently being viewed to a Student who is of a higher index value.
## If the Student is the last on of the array, roll over to the first Student.
func _on_next_pressed():
	change_student_page(1)

## This function will swap visiblity of the given Control nodes. _current_page, will be
## the one currently visible. The _target_page will be the Control node we wish to make visible. 
func swap_pages(_current_page: Control, _target_page: Control):
	_current_page.visible = false
	_target_page.visible = true

## This function will swap between StudentPages under the "Pages" Control node. It will
## handle all the logic that must be done when the pages are swapped and validates the given
## input to prvent errors. [PARAM: change_value must equal 1 or -1]
func change_student_page(change_value: int):
	assert(change_value in [1,-1], 
	"ERROR: change_value of change_student_page(change_value) must be 1 or -1.")
	## Get current page index
	var _current_page_index = $'Pages'.get_children().find(current_student_page) 
	## Get list of all StudentPage Nodes [due to a Control node, that isn't a StudentPage, existing]
	var student_nodes = $Pages.get_children().filter(func(_node): return _node is StudentPage) 
	var target_student_page_index = _current_page_index + change_value
	
	match change_value:
		1:
			if target_student_page_index > len(student_nodes) -1: ## If the result of 1 less than the target's index, then target the last StudentPage's index.
				target_student_page_index = $Pages.get_children().find(student_nodes[0])
		-1:
			if target_student_page_index < 0: ## If the result of 1 less than the target's index, then target the last StudentPage's index.
				target_student_page_index = $Pages.get_children().find(student_nodes[len(student_nodes) - 1])
				
	#$Pages.get_child(_current_page_index).swipe_out()
	$Pages.get_child(target_student_page_index).visible = true
	$Pages.get_child(_current_page_index).visible = false
	current_student_page = $'Pages'.get_child(target_student_page_index)


## When the button to play as a particular Student is pressed, this will call a 
## Global function to change currently selected Student that the player will control.
func _on_player_pressed():
	Global.change_selected("player", current_student_page.student)
	update_all_pages()

## When the button to have a particular Student as a Besty, this will call a
## Global function to change currently selected Student that the player will control.
func _on_besty_pressed():
	Global.change_selected("besty", current_student_page.student)
	update_all_pages()

## This will call the update function of the StudentPages Control nodes. It will
## only effect StudentPages that are under the "Pages" node. 
func update_all_pages():
	for student_page in get_node("Pages").get_children():
		if student_page is StudentPage:
			student_page.update()
