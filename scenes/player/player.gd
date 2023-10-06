extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var starting_direction: Vector2 = Vector2.RIGHT

@onready var direction: float = starting_direction.x
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var respawn_position: Vector2 = position

var prevDir: float = direction

var walking: bool = false
var waking: bool = false
var idle: bool = true

func _ready():
	update_animation_parameters(starting_direction.x)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Globals.player_movable:
		if Input.is_action_just_pressed("Jump") and is_on_floor():
			jump(1)
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
		direction = Input.get_axis("Left", "Right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		print("direction 1: " + str(direction))
		update_animation_parameters(direction)
	else:
		velocity.x = 0
	pick_new_state()
	move_and_slide()
	print("direction 2: " + str(direction))

func jump(value: float):
	velocity.y = JUMP_VELOCITY * value

#direction
func update_animation_parameters(direction : float):
	if(direction != 0):
		prevDir = direction
		animation_tree.set("parameters/Walk/blend_position", direction)
		animation_tree.set("parameters/Wake/blend_position", direction)

func pick_new_state():
	if(velocity.x != 0 || velocity.y != 0):
		if not waking:
			if (not walking) && idle:
				if direction < 0: 
					$AnimationPlayer.play("WakeLeft")
				else:
					$AnimationPlayer.play("WakeRight")
				waking = true
				await $AnimationPlayer.animation_finished
				waking = false
				idle = false
			else:
				state_machine.travel("Walk")
				walking = true
				idle = false
	else:
		if idle:
			state_machine.travel("Idle")
		else:
			walking = false
			if prevDir < 0: 
				$AnimationPlayer.play_backwards("WakeLeft")
			else:
				$AnimationPlayer.play_backwards("WakeRight")
			await $AnimationPlayer.animation_finished
			idle = true
