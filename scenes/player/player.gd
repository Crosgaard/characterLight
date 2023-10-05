extends CharacterBody2D


const MAX_SPEED = 300.0
const MOVEMENT_ACCEL = 3000
const JUMP_VELOCITY = -400.0
const DASH_SPEED : float = 2000
const DASH_COOLDOWN : float = 1000

var dash_slow : bool = false
var dashing : bool = false
var last_dash : float = 0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _process(delta):
	if Input.is_action_just_pressed("Dash") and Time.get_ticks_msec() - last_dash > DASH_COOLDOWN:
		dash_slow = true
		Engine.time_scale = 0.2
		

func _physics_process(delta):
	# Add the gravity.

	if dash_slow and Input.is_action_just_released("Dash"):
		dash_slow = false
		dashing = true
		last_dash = Time.get_ticks_msec()
		Engine.time_scale = 1
		var mouse = get_global_mouse_position()
		var dash = Vector2(mouse.x - position.x, mouse.y - position.y)
		dash = dash.normalized() * DASH_SPEED
		velocity = dash;
		
	if not is_on_floor():
		velocity.y += gravity * delta
	# Handle Jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if dashing:
		velocity.y += MOVEMENT_ACCEL * delta
		if velocity.y > 0:
			dashing = false
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Left", "Right")
	if direction < 0 and velocity.x > -MAX_SPEED:
		velocity.x += direction * MOVEMENT_ACCEL * delta
	elif direction > 0 and velocity.x < MAX_SPEED:
		velocity.x += direction * MOVEMENT_ACCEL * delta
	
	if (not Input.is_action_pressed("Left") and not Input.is_action_pressed("Right")) or (absf(velocity.x) > MAX_SPEED):
		if absf(velocity.x) < MOVEMENT_ACCEL * delta:
			velocity.x = 0
		elif velocity.x < 0:
			velocity.x += MOVEMENT_ACCEL * delta
		elif velocity.x > 0:
			velocity.x -= MOVEMENT_ACCEL * delta
	
	move_and_slide()
