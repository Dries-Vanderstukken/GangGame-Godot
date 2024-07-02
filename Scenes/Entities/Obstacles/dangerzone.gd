extends Area2D


#Signal for body entering danger zone
func _on_body_entered(body):
	if body is Player:
		body.handle_danger()
		
	
