extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -350.0
const ACCELERATION = 1500
const ACCELERATION_AIR = 800
const FRICTION = 0.13
var start = true
var dead = false
var dead_by_enemy = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	var coinlabel = get_child(get_child_count() - 1).get_node("Label")
	coinlabel.text = "Coins: " + str(Main.coins)
	var livelabel = get_child(get_child_count() - 1).get_node("Lives")
	livelabel.text = "Lives: " + str(Main.lives)
	get_child(3).get_child(2).fade_in()
	
func attack():
	var timer = get_child(0)
	if timer.is_stopped():
		timer.start(0.375)
		$AudioStreamSword.play()
		timer.set_one_shot(true)
		
	
	
func enemy():
	var enemy = get_parent().get_child(2).get_children()
	for e in enemy:
		var deltaX = e.position.x-position.x
		var deltaY = sqrt(pow(e.position.y-position.y,2.0))
		var heading = $AnimatedSprite2D.flip_h
		if (deltaX > -15 && deltaX < 10) && heading && deltaY < 20:
			if get_child(0).get_time_left() > 0:		
				enemycoin(e)
				e.death()
				
					
		elif(deltaX < 15 && deltaX > 10) && !heading && deltaY < 20:
			if get_child(0).get_time_left() > 0:	
				enemycoin(e)
				e.death()
				
		elif(deltaX < 11 && deltaX > -11) && deltaY < 20:
			if !dead_by_enemy:
				dead_by_enemy = true
				death("PlayerLink")
				
				
	
func enemycoin(e):
	var tilemap = get_parent().get_node("TileMap")
	var tilemapcoords = tilemap.local_to_map(e.global_position)
	var atlascoords = tilemap.get_cell_atlas_coords(0,tilemapcoords)
	var random = randi_range(0,1)
	tilemap.set_cell(0,tilemapcoords,2,Vector2i(random,random))


func coin_collect():
	var tilemap = get_parent().get_node("TileMap")
	var data = gimmegimmegimmeyourblocks(0,0)
	
		
	if data.a_coords == Vector2i(0,1) && data.s_id == 2:
		$AudioStreamRupee.play()
		tilemap.set_cell(0,data.coords,-1)
		
		# Handles global coin count
		Main.coins += 1
		print("Godot Hurensohn")
		var coinlabel = get_child(get_child_count() - 1).get_node("Label")
		coinlabel.text = "Coins: " + str(Main.coins)
		
	if data.a_coords == Vector2i(0,0) && data.s_id == 2:
		$AudioStreamRupee.play()
		tilemap.set_cell(0,data.coords,-1)
		
		# Handles global coin count
		Main.coins += 5
		print("Godot Hurensohn x5")
		var coinlabel = get_child(get_child_count() - 1).get_node("Label")
		coinlabel.text = "Coins: " + str(Main.coins)
	
	if data.a_coords == Vector2i(1,1) && data.s_id == 2:
		$AudioStreamRupee.play()
		tilemap.set_cell(0,data.coords,-1)
		
		# Handles global coin count
		Main.coins += 20
		print("Godot Hurensohn xJackpot")
		var coinlabel = get_child(get_child_count() - 1).get_node("Label")
		coinlabel.text = "Coins: " + str(Main.coins)
		
func gimmegimmegimmeyourblocks(w,layer):
	var tilemap = get_parent().get_node("TileMap")
	var tilemapcoords = tilemap.local_to_map(global_position)
	tilemapcoords.x -= w
	var atlascoords = tilemap.get_cell_atlas_coords(layer,tilemapcoords)
	var source_id = tilemap.get_cell_source_id(layer,tilemapcoords)
	return {"coords":tilemapcoords,"a_coords":atlascoords,"s_id":source_id}
	
func anime():
	if dead:
		$AnimatedSprite2D.play("death")
	elif (get_child(0).get_time_left() > 0):
		$AnimatedSprite2D.play("attack")
	elif velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("default")
	elif velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("default")
	elif velocity.x == 0:
		$AnimatedSprite2D.play("idle")
	
	
func _physics_process(delta):
	coin_collect()

	if $AnimatedSprite2D.animation_finished:
		anime()
		
	if Input.is_action_pressed("attack_btn"):
		attack()

		
		
	enemy()
	
	if start:
		velocity.x = 100
		start = false
	else:
		var direction = 0
		if !dead:
			direction = Input.get_axis("ui_left", "ui_right")
		
			var VELX = 0
			if not is_on_floor():
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
				velocity.x = ACCELERATION*delta + velocity.x - FRICTION*velocity.x
			elif direction < 0 and is_on_floor():
				velocity.x = -ACCELERATION*delta + velocity.x - FRICTION*velocity.x
			elif is_on_floor():
				velocity.x = velocity.x - FRICTION*1.8*velocity.x
				if velocity.x < 0.1 and velocity.x > -0.1:
					velocity.x = 0

	move_and_slide()


func _on_dungeon_body_entered(body):
	if body.name == "PlayerLink":
		get_node("Camera2D/Draußen").visible = false
		get_node("Camera2D/Dungeon").visible = true
		$AudioStreamMusic.stop()
		$AudioStreamDungeon.play()


func _on_dungeon_body_exited(body):
	if body.name == "PlayerLink" && !dead:
		get_node("Camera2D/Draußen").visible = true
		get_node("Camera2D/Dungeon").visible = false
		$AudioStreamDungeon.stop()
		$AudioStreamMusic.play()

func _on_death_body_entered(body):
	death(body.name)
	
func death(name):
	if name == "PlayerLink":
		# Handles global live count
		Main.lives -= 1
		var livelabel = get_child(get_child_count() - 1).get_node("Lives")
		livelabel.text = "Lives: " + str(Main.lives)
		
		dead = true
		Main.dead = true
		$AudioStreamMusic.stop()
		$AudioStreamDungeon.stop()
		$AudioStreamDeath.play()
		set_collision_layer_value(1,false)
		set_collision_layer_value(2,false)
		set_collision_mask_value(1,false)
		set_collision_mask_value(2,false)
		var c_pos = get_node("Camera2D").get_screen_center_position().y
		get_node("Camera2D").set_limit(SIDE_BOTTOM,c_pos+143)
		velocity.x = 0
		velocity.y = -150
		
		for i in range(30):
			await get_tree().create_timer(0.08).timeout
			velocity.y += gravity*0.02
		
		Main.dead = false
		if Main.lives != 0:
			get_child(3).get_child(2).fade_out()
			await get_tree().create_timer(0.3).timeout
			get_tree().change_scene_to_file("res://scenes/Level2.tscn")
		else:
			Main.coins = 0
			Main.lives = 3
			# Put Game Over Animation here
			get_child(3).get_child(2).fade_out()
			$AudioStreamGameOver.play()
			await get_tree().create_timer(0.5).timeout
			get_child(3).get_child(2).game_over()
			await get_tree().create_timer(12.5).timeout
			get_tree().change_scene_to_file("res://scenes/start_screen.tscn")
			
