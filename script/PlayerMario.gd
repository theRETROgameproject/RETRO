extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -375.0
const ACCELERATION = 1500
const ACCELERATION_AIR = 800
const FRICTION = 0.13
var coins = 0
var hit_flag = false
var won_sound = false
var slide_sound = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func gimmegimmegimmeyourblocks(h,layer):
	var tilemap = get_parent().get_node("TileMap")
	var tilemapcoords = tilemap.local_to_map(global_position)
	tilemapcoords.y -= h
	var atlascoords = tilemap.get_cell_atlas_coords(layer,tilemapcoords)
	var source_id = tilemap.get_cell_source_id(layer,tilemapcoords)
	return {"coords":tilemapcoords,"a_coords":atlascoords,"s_id":source_id}
	
func coinspawn():
	var tilemap = get_parent().get_node("TileMap")
	var data = gimmegimmegimmeyourblocks(1,1)
	if data.a_coords == Vector2i(0,0) && data.s_id == 2:
		tilemap.set_cell(1,data.coords,2,Vector2(0,1))
		data.coords.y -= 1
		tilemap.set_cell(1,data.coords,2,Vector2(4,0))
		
func coin_collect():	
	var tilemap = get_parent().get_node("TileMap")
	var data = gimmegimmegimmeyourblocks(0,1)
	if data.a_coords == Vector2i(4,0) && data.s_id == 2:
		$AudioStreamCoin.play()
		tilemap.set_cell(1,data.coords,-1)
		coins += 1
		var coinlabel = get_parent().get_node("CanvasLayer/Label")
		coinlabel.text = str("Coins: ", coins )
	
func flag():
	# var tilemap = get_parent().get_node("TileMap")
	var data = gimmegimmegimmeyourblocks(0,1)
	if (data.a_coords == Vector2i(7,1) && data.s_id == 2) || (data.a_coords == Vector2i(6,1) && data.s_id == 2):
		hit_flag = true
		if not slide_sound:
			$AudioStreamMusic.stop()
			$AudioStreamSlide.play()
			slide_sound = true
		velocity.x = 0
		velocity.y = 50
	if is_on_floor() && hit_flag:
		if not won_sound:
			$AudioStreamSlide.stop()
			$AudioStreamWon.play()
			won_sound = true
		velocity.x = 60
		velocity.y = 200
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("default")
		await get_tree().create_timer(4).timeout
		velocity.x = 0
		get_tree().change_scene_to_file("res://scenes/death_screen.tscn")
		
func _physics_process(delta):
	coinspawn()
	coin_collect()
	flag()
	
	var direction = 0
	if !hit_flag:
		direction = Input.get_axis("ui_left", "ui_right")
		
		var VELX = 0
		if not is_on_floor():
			if direction >= 0:
				$AnimatedSprite2D.flip_h = false
				$AnimatedSprite2D.play("jump")
			elif direction <= 0:
				$AnimatedSprite2D.flip_h = true
				$AnimatedSprite2D.play("jump")
			velocity.y += gravity * delta
			if direction > 0 and velocity.x < VELX+70:
				velocity.x += 10
			if direction < 0 and velocity.x > VELX-70:
				velocity.x -= 10

	# Handle Jump.
		if Input.is_action_just_pressed("ui_accept"):# and is_on_floor():
			velocity.y = JUMP_VELOCITY
			VELX = velocity.x
			$AudioStreamJump.play()

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
			velocity.x = velocity.x - FRICTION*1.8*velocity.x
			$AnimatedSprite2D.play("idle")
			if velocity.x < 0.1 and velocity.x > -0.1:
				velocity.x = 0

	move_and_slide()

func _on_death_body_entered(body):
	if body.name == "PlayerMario":
		$AudioStreamDeath.play()
		await get_tree().create_timer(4).timeout
		get_tree().change_scene_to_file("res://scenes/death_screen.tscn")
