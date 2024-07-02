extends CharacterBody2D

const SPEED = 500
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var coyote_timer = $CoyoteTimer

var can_control : bool = true

func PhysicsUpdate():
