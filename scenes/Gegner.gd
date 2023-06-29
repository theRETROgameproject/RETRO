extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y += gravity * delta
		
	var playerXpos = get_parent().get_parent().get_node("PlayerLink").position.x
	if position.x-playerXpos > 5:
		velocity.x = -50
	elif position.x-playerXpos < -5: 
		velocity.x = 50
	else:
		velocity.x = 0
		
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("default")
	elif velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("default")
	else:
		$AnimatedSprite2D.play("idle")
	
	move_and_slide()
