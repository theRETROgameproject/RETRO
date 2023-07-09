extends CharacterBody2D

var dead = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	get_child(2).get_child(0).fade_in()
	velocity.x = 27

func anime():
	if dead:
		$AnimatedSprite2D.play("death")
	elif velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("default")
	elif velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("default")

func _physics_process(delta):
	
	anime()
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	
	move_and_slide()


func _on_gommehd_net_body_entered(body):
	if body.name == "PlayerKnight":
		velocity.x = 0
		get_child(2).get_child(0).blitz()
		await get_tree().create_timer(1.0).timeout
		dead = true
		
