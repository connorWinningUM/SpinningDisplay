extends RigidBody3D

@onready var audio : AudioStreamPlayer3D = get_node("AudioStreamPlayer3D")
@onready var win_sound : AudioStreamPlayer3D = get_node("win")

@onready var goal1 : Area3D = get_parent().get_node("Goal1");
@onready var goal2 : Area3D = get_parent().get_node("Goal2");

@onready var padle1 : CharacterBody3D = get_parent().get_node("Padle1");
@onready var padle2 : CharacterBody3D = get_parent().get_node("Padle2");

@onready var score1 : Label = get_parent().get_node("ui_overlay").get_node("P1").get_node("score")
var score1_val = 0;
@onready var score2 : Label = get_parent().get_node("ui_overlay").get_node("P2").get_node("score")
var score2_val = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gravity_scale = 0
	linear_velocity.x = 5;
	linear_velocity.y = 5;
	
	contact_monitor = true;
	

var can_score = true;
@export var score_cooldown = 1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if goal1 && goal1.overlaps_body(self) && can_score:
		giveGoal1();
		can_score = false
		var timer = get_tree().create_timer(score_cooldown)
		await timer.timeout
		can_score = true
		
	if goal2 && goal2.overlaps_body(self) && can_score:
		giveGoal2();
		can_score = false
		var timer = get_tree().create_timer(score_cooldown)
		await timer.timeout
		can_score = true
		
	if padle1 && padle1.get_node("PadleArea1").overlaps_body(self):
		audio.play()
		
	if padle2 && padle2.get_node("PadleArea2").overlaps_body(self):
		audio.play()
		
	if(abs(linear_velocity.x) < 5):
		linear_velocity.x = 5 * sign(linear_velocity.x)
		
		
	
func giveGoal1() -> void:
	position = Vector3(0, 4, 0);
	linear_velocity = Vector3(-5, 5, 0);
	score1_val += 1
	score1.text = str(score1_val)
	print("HIT GOAL 1")
	win_sound.play()
	
	
func giveGoal2() -> void:
	position = Vector3(0, 4, 0);
	linear_velocity = Vector3(5, 5, 0);
	score2_val += 1
	score2.text = str(score2_val)
	print("HIT GOAL 2")
	win_sound.play()
