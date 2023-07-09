extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -375.0
const ACCELERATION = 1500
const ACCELERATION_AIR = 800
const FRICTION = 0.13
var hit_flag = false
var dead = false
var won_sound = false
var slide_sound = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	var coinlabel = get_child(get_child_count() - 1).get_node("Label")
	coinlabel.text = "Coins: " + str(Main.coins)
	var livelabel = get_child(get_child_count() - 1).get_node("Lives")
	livelabel.text = "Lives: " + str(Main.lives)
	
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
		
		# Handles global coin count
		Main.coins += 1
		print("Godot Hurensohn")
		var coinlabel = get_child(get_child_count() - 1).get_node("Label")
		coinlabel.text = "Coins: " + str(Main.coins)
	
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
		get_tree().change_scene_to_file("res://scenes/Level2.tscn")
		
func _physics_process(delta):
	coinspawn()
	coin_collect()
	flag()
	
	var direction = 0
	if !hit_flag && !dead:
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
		if Input.is_action_pressed("ui_accept") and is_on_floor():
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
		dead = true
		$AudioStreamMusic.stop()
		$AudioStreamDeath.play()
		set_collision_layer_value(1,false)
		set_collision_layer_value(2,false)
		set_collision_mask_value(1,false)
		set_collision_mask_value(2,false)
		var c_pos = get_node("Camera2D").get_screen_center_position().y
		get_node("Camera2D").set_limit(SIDE_BOTTOM,c_pos+143)
		velocity.x = 0
		velocity.y = -150
		$AnimatedSprite2D.play("death")
		for i in range(30):
			await get_tree().create_timer(0.08).timeout
			velocity.y += gravity*0.02
		
		# Handles global live count
		print("test")
		Main.lives -= 1
		if Main.lives != 0:
			get_tree().change_scene_to_file("res://scenes/Level1.tscn")
		else:
			Main.coins = 0
			Main.lives = 3
			# Put Game Over Animation here
			# $AudioStreamGameOver.play()
			get_tree().change_scene_to_file("res://scenes/start_screen.tscn")
