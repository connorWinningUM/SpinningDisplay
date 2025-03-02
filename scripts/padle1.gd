extends CharacterBody3D

@onready var rotate_sensitivity = get_parent().get_node("PauseMenu1").get_node("VBoxContainer").get_node("RotationSensitivity").get_node("HSlider").value;

@onready var start_pos_z = position.z;

@onready var SPEED = 5
const JUMP_VELOCITY = 4.5

func _process(delta: float) -> void:
	#prevent the ball from pushing the padle back
	position.z = start_pos_z;
	SPEED = get_parent().get_node("PauseMenu1").get_node("VBoxContainer").get_node("Sensitivity").get_node("HSlider").value
	rotate_sensitivity = get_parent().get_node("PauseMenu1").get_node("VBoxContainer").get_node("RotationSensitivity").get_node("HSlider").value;
	

var target_rotation_verticle = deg_to_rad(90)
var target_rotation = deg_to_rad(90)
func _physics_process(delta: float) -> void:

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("P1Right", "P1Left", "P1Down", "P1Up")
	var direction := (Vector3(input_dir.x, input_dir.y, 0)).normalized()
	if direction:
		velocity.z = direction.x * SPEED
		velocity.y = direction.y * SPEED
	else:
		velocity.z = move_toward(velocity.z, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
	#implement the push and pull of the padel (rotate up and down about z)
	var rotate := Input.get_axis("P1PushUp", "P1PushDown")
	if rotate != 0:
		target_rotation_verticle += rotate * rotate_sensitivity * delta
	else:
		target_rotation_verticle = lerp(target_rotation_verticle, deg_to_rad(90.0), rotate_sensitivity * delta)
		
	var min_rotation = deg_to_rad(90.0) - deg_to_rad(45.0)
	var max_rotation = deg_to_rad(90.0) + deg_to_rad(45.0)
	target_rotation_verticle = clamp(target_rotation_verticle, min_rotation, max_rotation)
	
	rotation.z = target_rotation_verticle + deg_to_rad(90.0);
	
	rotate = Input.get_axis("P1PushLeft", "P1PushRight")
	if rotate != 0:
		# Apply the input with speed and delta time for frame-rate independence
		target_rotation += rotate * rotate_sensitivity * delta
	else:
		target_rotation = lerp(target_rotation, deg_to_rad(90.0), rotate_sensitivity * delta)
		
	
	min_rotation = deg_to_rad(90.0) - deg_to_rad(45.0)
	max_rotation = deg_to_rad(90.0) + deg_to_rad(45.0)
	target_rotation = clamp(target_rotation, min_rotation, max_rotation)
	
	rotation.y = target_rotation
	move_and_slide()
