class_name Player
extends CharacterBody2D


const SPEED = 500.0
const JUMP_VELOCITY = -1200.0
var gravity_multiplier = 1
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var coyote_timer = $CoyoteTimer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_control : bool = true


func _physics_process(delta):
	if not can_control: return
	
	# Animations
	if (velocity.x > 1 || velocity.x < -1):
		animated_sprite_2d.animation = "Walk"
	else:
		animated_sprite_2d.animation = "Idle"
		
	# Faster fall after jump height reached
	if velocity.y > 0:
		gravity_multiplier += 0.5
		
	# Smaller jumps if jump button released
	if Input.is_action_just_released("Jump") and velocity.y < -300:
		gravity_multiplier += 10
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta * gravity_multiplier
		gravity_multiplier = 1
		animated_sprite_2d.animation = "Jump"

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and (is_on_floor() || !coyote_timer.is_stopped()):
		velocity.y = JUMP_VELOCITY
		
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
		if direction > 0:
			animated_sprite_2d.flip_h = 0
		else:
			animated_sprite_2d.flip_h = 1
	else:
		velocity.x = move_toward(velocity.x, 0, 50)

	var was_on_floor = is_on_floor()
	move_and_slide()
	if (was_on_floor == !is_on_floor()):
		coyote_timer.start()


func handle_danger() -> void:
	print("Faster than recall")
	visible = false
	can_control = false 
	
	await get_tree().create_timer(1).timeout
	reset_player()

func reset_player() -> void:
	global_position = Vector2(200,200)
	visible = true
	can_control = true
	
	
	
	
