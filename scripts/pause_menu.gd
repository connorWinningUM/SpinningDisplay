extends Control

var selectedElement = -1;
@onready var amount_elements = get_node("VBoxContainer").get_child_count() - 2;
@onready var buttons = get_node("VBoxContainer").get_children().filter(return_elements);
var pause_action_name = ""

# Configuration variables
@export var slider_fast_step: float = 3  # Faster step when holding direction
@export var input_delay: float = 0.4  # Initial delay before repeating
@export var input_repeat: float = 0.05  # How quickly to repeat after initial delay


# Input tracking
var input_direction: Vector2 = Vector2.ZERO
var holding_time: float = 0
var is_holding: bool = false

func _ready() -> void:
	#manually set the delay step
	get_node("VBoxContainer").get_node("delay").get_node("HSlider").step = 0.000001;
	
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	
	set_Button_Focus()
	pause_action_name = "P1" if name == "PauseMenu1" else "P2"

func _process(delta: float) -> void:
	if Input.is_action_just_pressed(pause_action_name+"pause"):
		_on_pause();
	
	if(visible && Input.is_action_pressed(pause_action_name+"back")):
		print("UNPAUSE")
		toggle_pause()
	
	if(Input.is_action_just_pressed(pause_action_name+"Down")):
		if(selectedElement < amount_elements):
			selectedElement += 1;
			if(buttons[selectedElement] is BoxContainer):
				buttons[selectedElement].get_node("HSlider").grab_focus()
			else:
				buttons[selectedElement].grab_focus()
			
	if(Input.is_action_just_pressed(pause_action_name+"Up")):
		if(selectedElement >= 0):
			selectedElement -= 1;
			if(buttons[selectedElement] is BoxContainer):
				buttons[selectedElement].get_node("HSlider").grab_focus()
			else:
				buttons[selectedElement].grab_focus()
			
	
	#do left right input
	var node_in_focus = get_viewport().gui_get_focus_owner();
	if(node_in_focus is HSlider):
		
		var horizontal_input = Input.get_axis(pause_action_name+"Left", pause_action_name+"Right")
		if horizontal_input != 0:
			if input_direction.x == 0 or sign(input_direction.x) != sign(horizontal_input):
				# Apply immediate change
				change_slider_value(node_in_focus, horizontal_input)
				holding_time = 0
				is_holding = true
			else:
				# Handle continuous holding
				holding_time += delta
				if holding_time >= input_delay:
					# Calculate how many steps to take based on held time
					var repeat_steps = floor((holding_time - input_delay) / input_repeat)
					if repeat_steps > 0:
						# Apply change and adjust holding time
						change_slider_value(node_in_focus, horizontal_input, true)
						holding_time -= repeat_steps * input_repeat
			input_direction.x = horizontal_input
			
		else:
			# Reset when no input
			input_direction.x = 0
			holding_time = 0
			is_holding = false
	
	elif(node_in_focus is Button):
		if(Input.is_action_just_pressed(pause_action_name+"select")):
			toggle_pause()

func change_slider_value(slider, direction, is_fast = false):
	
	# Choose step size based on whether it's a fast adjustment
	var step = slider.step*slider_fast_step if is_fast else slider.step
	
	# Calculate new value and clamp to slider range
	var new_value = slider.value + (step * sign(direction))
	new_value = clamp(new_value, slider.min_value, slider.max_value)
	
	# Set the slider value
	slider.value = new_value
	
	
	# If slider has a custom step, snap to it
	if slider.step > 0:
		slider.value = round(slider.value / slider.step) * slider.step

func toggle_pause():
	# Toggle the game's pause state
	get_tree().paused = !get_tree().paused
	
	# Show/hide the pause menu
	visible = get_tree().paused
	
func _on_pause():
	selectedElement = 0; #reset to before the first element on pause

func set_Button_Focus():
	for element in buttons:
		if(element is BoxContainer):
			element.get_node("HSlider").set_focus_mode(Control.FOCUS_ALL)
		elif element is Button:
			element.set_focus_mode(Control.FOCUS_ALL)

func return_elements(child):
	if(child is Button):
		return child;
	if(child is BoxContainer):
		return child;
