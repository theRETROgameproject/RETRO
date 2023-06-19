extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -375.0
const ACCELERATION = 1500
const ACCELERATION_AIR = 800
const FRICTION = 0.12

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	var direction = Input.get_axis("ui_left", "ui_right")
	var VELX = 0
	if not is_on_floor():
		if direction > 0:
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("jump")
		elif direction < 0:
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("jump")
		velocity.y += gravity * delta
		if direction > 0 and velocity.x < VELX+70:
			velocity.x += 10
		if direction < 0 and velocity.x > VELX-70:
			velocity.x -= 10

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		VELX = velocity.x

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	if direction > 0 and is_on_floor():
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("default")
		velocity.x = ACCELERATION*delta + velocity.x - FRICTION*velocity.x
	elif direction < 0 and is_on_floor():
		velocity.x = -ACCELERATION*delta + velocity.x - FRICTION*velocity.x
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("default")
	elif is_on_floor():
		velocity.x = velocity.x - FRICTION*1.5*velocity.x
		$AnimatedSprite2D.play("idle")
		if velocity.x < 0.1 and velocity.x > -0.1:
			velocity.x = 0

	move_and_slide()
