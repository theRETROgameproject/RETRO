extends CharacterBody2D

var dead = false
var dies = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	get_child(2).get_child(0).fade_in()
	velocity.x = 27

func anime():
	if dead:
		$AnimatedSprite2D.play("dead")
	elif dies:
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
		
		$AudioStreamDeath.play()
		get_child(2).get_child(0).blitz()
		dies = true
		await get_tree().create_timer(3.2).timeout
		get_child(2).get_child(0).blitz()
		await get_tree().create_timer(0.5).timeout
		dead = true
		get_child(2).get_child(0).you_died()
		$AudioStreamDeath.stop()
		$AudioStreamMusic.stop()
		$AudioStreamWon.play()
		await get_tree().create_timer(3).timeout
		get_child(2).get_child(0).fade_out()
		await get_tree().create_timer(1.5).timeout
		get_child(2).get_child(0).completed()
		await get_tree().create_timer(25).timeout
		get_tree().change_scene_to_file("res://scenes/start_screen.tscn")
