class_name Player
extends CharacterBody2D
 
#In case of death
var can_control : bool = true
 
#Shenanigans to make the dash work
const dashspeed = 2000
const dashlength = 0.1
const dashcooldown = 0.3
var can_dash: bool = true
@onready var dash = $Dash 
 
#Gravity and normal movement
const normalspeed = 500.0
const JUMP_VELOCITY = -1200.0
var gravity_multiplier = 1
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var coyote_timer = $CoyoteTimer
 
func _physics_process(delta):
	#In case of death
	if not can_control: return
	#reset dash on floor
	if is_on_floor():
		can_dash = true
 
	if Input.is_action_just_pressed("Dash") and dash.on_cooldown() and can_dash:
		dash.start_dash(dashlength, dashcooldown)
		if not is_on_floor():
			can_dash = false
	var SPEED = dashspeed if dash.is_dashing() else normalspeed
 
	# Faster fall after jump height reached
	if velocity.y > 0:
		gravity_multiplier += 0.5
 
	# Smaller jumps if jump button released
	if Input.is_action_just_released("Jump") and velocity.y < -300:
		gravity_multiplier += 10
 
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta * gravity_multiplier
		
		#Stop gravity while dashing
		velocity.y = 0 if (dash.is_dashing() and velocity.x != 0) else velocity.y
		
		gravity_multiplier = 1
		
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
 	
	# Animation
	if Input.is_action_just_pressed("Dash") and dash.is_dashing():
		animated_sprite_2d.animation = "Dash"
	if (animated_sprite_2d.animation == "Dash" and animated_sprite_2d.frame < 15):
		animated_sprite_2d.frame_progress += 1
	else:
		
		if not is_on_floor():
			animated_sprite_2d.animation = "Jump"
			if velocity.y > 0 and not (animated_sprite_2d.frame in range(1,7)):
				animated_sprite_2d.frame = 7
			else:
				pass
		
		elif (velocity.x > 1|| velocity.x < -1):
			animated_sprite_2d.animation = "Walk"
		else:
			animated_sprite_2d.animation = "Idle"

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
	global_position = Vector2(263,600)
	visible = true
	can_control = true
	
