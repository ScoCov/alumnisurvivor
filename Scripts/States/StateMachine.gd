extends Node

#region DESCRIPTION NOTE
##	The state machine will handle what state the player unit is in, when to change,
##	and logic surrounding the player's state. 
##
##	These states will have their own respective logic associated with them.
##
##	Example:
##
##	The player is not moving, so their state will be "Idle":
##		- When in this state, the player will play an idle animation.
##
##	Once the player starts to move, the state of the player will change to "Moving":
##		- This will play the moving animation and allow the dash ability to be used.
##
#endregion

##	Start with an initial state. Can be assigned via the editor.
@export var initial_state: State

var current_state: State ## Currently in use State 
##	The states variable will be used to grab all the States that will be child nodes to this
##	state machine. 
var states: Dictionary = {} 


func _ready():
	for child in get_children():
		if child is State:##	If child is a state, add to states dictionary.
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
			
	if initial_state: ## If there is an initial state, call its' enter method. 
		initial_state.enter()
		current_state = initial_state ## Don't forget to assign the initial state!
			
func _process(delta): ## call the state's update method, if it exists.
	if current_state:
		current_state.update(delta)
		
func _physics_process(delta): ## call the state's physics update methd, if it exists.
	if current_state:
		current_state.physics_update(delta)

func on_child_transition(state, new_state_name): ## Called whenever state has been changed
	if (state != current_state): ## Exit the function if the state is already in effect
		return 
		
#region NOTE: Empty-Return
##	This empty return is a way to exit a function so you don't waste time trying to 
##	do other actions that will crash, slowdown, or cost unnecessary resources (eg: RAM). 
#endregion
		
	var new_state = states.get(new_state_name.to_lower())
	if !new_state: ## If the new state given couldn't be found in the states dictionary, exit function.
		return
		 
	if current_state: ## If thre is a Current State, call it's exit method.
		current_state.exit()
		
	##	Finally, you will call the enter method of the new state,
	##	and then make it the current state.
	new_state.enter() 
	current_state = new_state
