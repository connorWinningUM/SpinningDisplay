extends Node3D

@onready var Camera1 : Camera3D = get_node("Camera3D1");
@onready var Camera2 : Camera3D = get_node("Camera3D2");
@onready var pause_menu1 = get_node("PauseMenu1");
@onready var pause_menu2 = get_node("PauseMenu2");

@onready var music : AudioStreamPlayer3D = get_node("music")

@export var swapDelay: float = 0.0006849;
var timeSinceSwapDisplay: float = 0.0;
var currentCamera : Camera3D = Camera1;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Camera1.current = true;
	pause_menu1.visible = false
	pause_menu2.visible = false
	music.connect("finished", Callable(self,"_on_loop_sound").bind(music))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	timeSinceSwapDisplay += delta;
	if(timeSinceSwapDisplay >= swapDelay):
		timeSinceSwapDisplay = 0;
		if(currentCamera == Camera1):
			currentCamera = Camera2;
		else:
			currentCamera = Camera1;
			
		currentCamera.current = true;
		
	#check if paused
	if(Input.is_action_just_pressed("P1pause")):
		toggle_pause1();
		
	if(Input.is_action_just_pressed("P2pause")):
		toggle_pause2();
		
	#update swap delay from pause menu
	swapDelay = 100000000;
	#swapDelay = pause_menu1.get_node("VBoxContainer").get_node("delay").get_node("HSlider").value;
	

func toggle_pause1():
	# Toggle the game's pause state
	get_tree().paused = !get_tree().paused
	
	# Show/hide the pause menu
	pause_menu1.visible = get_tree().paused
	
	print("Game paused: ", get_tree().paused)

func toggle_pause2():
	# Toggle the game's pause state
	get_tree().paused = !get_tree().paused
	
	# Show/hide the pause menu
	pause_menu2.visible = get_tree().paused
	
	print("Game paused: ", get_tree().paused)
	
func _on_loop_sound(player):
	player.play()
