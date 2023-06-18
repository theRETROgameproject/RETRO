extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -300.0
const ACCELARTION = 2000
const FRICTION = 0.2

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction > 0 and is_on_floor():
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("default")
		velocity.x = ACCELARTION*delta + velocity.x - FRICTION*velocity.x
	elif direction < 0 and is_on_floor():
		velocity.x = -ACCELARTION*delta + velocity.x - FRICTION*velocity.x
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("default")
	elif is_on_floor():
		velocity.x = velocity.x - FRICTION*velocity.x
		$AnimatedSprite2D.play("idle")
		if velocity.x < 0.1 and velocity.x > -0.1:
			velocity.x = 0

	move_and_slide()
