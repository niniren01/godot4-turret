extends CharacterBody3D
@onready var camera_pos: Node3D = $CameraPos

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("quit"):
		get_tree().quit()
		
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * 0.15
		camera_pos.rotation_degrees.x -= event.relative.y * 0.15
		camera_pos.rotation_degrees.x = clamp(camera_pos.rotation_degrees.x, -80, 90)

func _physics_process(delta: float) -> void:

	var up_down_dir := Input.get_axis("ctrl", "ui_accept")
	if up_down_dir:
		velocity.y = up_down_dir * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
