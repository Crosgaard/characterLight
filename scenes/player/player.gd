extends CharacterBody2D
@export var starting_direction: Vector2 = Vector2.RIGHT
@onready var direction: float = starting_direction.x
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var respawn_position: Vector2 = position

const MAX_SPEED = 300.0
const MOVEMENT_ACCEL = 3000
const JUMP_VELOCITY = -400.0
const DASH_SPEED: float = 1500
const DASH_SLOW_TIME: float = 1500
const DASH_COOLDOWN: float = 250

var dash_slow: bool = false
var dashing: bool = false
var can_dash: bool = true
var last_dash: float = 0
var last_dash_slow: float = 0
var original_time_scale_speed: float = 0.1
var time_scale_speed: float = original_time_scale_speed

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var prevDir: float = direction

var walking: bool = false
var waking: bool = false
var idle: bool = true

func _ready():
	update_animation_parameters()

func _process(delta):
	if Input.is_action_just_pressed("Dash") and can_dash and Time.get_ticks_msec() - last_dash > DASH_COOLDOWN:
		dash_slow = true
		if not is_on_floor():
			Engine.time_scale = time_scale_speed
	if dash_slow and Time.get_ticks_msec() - last_dash_slow > DASH_SLOW_TIME and not is_on_floor():
		Engine.time_scale *= 1.05
		if Engine.time_scale > 1:
			Input.action_release("Dash")

func _physics_process(delta):
	# Add the gravity.
	if dash_slow and Input.is_action_just_released("Dash"):
		dash_slow = false
		can_dash = false
		dashing = true
		last_dash = Time.get_ticks_msec()
		Engine.time_scale = 1
		var mouse = get_global_mouse_position()
		var dash = Vector2(mouse.x - position.x, mouse.y - position.y)
		dash = dash.normalized() * DASH_SPEED
		velocity = dash;
		
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		can_dash = true
	
	# Handle Jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if dashing:
		velocity.y += MOVEMENT_ACCEL * delta
		if velocity.y > 0:
			dashing = false
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("Left", "Right")
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
	
	update_animation_parameters()
	pick_new_state()
	
	move_and_slide()
	check_enemy_collisions()

func jump(value: float):
	velocity.y = JUMP_VELOCITY * value

func check_enemy_collisions():
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider.name == "KillMap":
			die()

func die():
	position = respawn_position
#animation
func update_animation_parameters():
	if(direction != 0):
		prevDir = direction
		animation_tree.set("parameters/Walk/blend_position", direction)
		animation_tree.set("parameters/Wake/blend_position", direction)

func pick_new_state():
	if(velocity.x != 0 || velocity.y != 0):
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")
