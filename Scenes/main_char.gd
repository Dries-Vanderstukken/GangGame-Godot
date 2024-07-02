extends CharacterBody2D


const SPEED = 500.0
const JUMP_VELOCITY = -1200.0
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var coyote_timer = $CoyoteTimer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Animations
	if (velocity.x > 1 || velocity.x < -1):
		animated_sprite_2d.animation = "Walk"
	else:
		animated_sprite_2d.animation = "Idle"
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		animated_sprite_2d.animation = "Jump"

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and (is_on_floor() || !coyote_timer.is_stopped()):
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
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
