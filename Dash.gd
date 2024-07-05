extends Node2D

@onready var timer = $DashTimer
@onready var cooldown_timer = $DashCooldown

func start_dash(duration, cooldown):
	timer.wait_time = duration
	cooldown_timer.wait_time = cooldown
	timer.start()
	cooldown_timer.start()
	
func is_dashing():
	return !timer.is_stopped()

func on_cooldown():
	return !cooldown_timer.is_stopped()
