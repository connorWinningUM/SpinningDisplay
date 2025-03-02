extends Node2D

@export var swapDelay: float = 0.0006849;

@onready var canvas1 = get_node("Canvas1");
@onready var canvas2 = get_node("Canvas2");


var timeSinceSwapDisplay = 0;
var isVisible = true;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	swapDelay = 0.0006849;
	print("SWAPDELAY: ", swapDelay);
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timeSinceSwapDisplay += delta;
	
	if(timeSinceSwapDisplay >= swapDelay):
		print("SWAPDELAY: ", swapDelay);
		isVisible = !isVisible;
		canvas1.visible = isVisible;
		canvas2.visible = !isVisible;
		timeSinceSwapDisplay = 0.0;
	
	pass
