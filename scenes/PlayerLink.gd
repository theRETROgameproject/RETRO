extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -350.0
const ACCELERATION = 1500
const ACCELERATION_AIR = 800
const FRICTION = 0.13
var start = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func enemy():
	var enemy = get_parent().get_child(2).get_children()
	for e in enemy:
		var deltaX = e.position.x-position.x
		var deltaY = sqrt(pow(e.position.y-position.y,2.0))
		var heading = $AnimatedSprite2D.flip_h
		if (deltaX > -15 && deltaX < 10) && heading && deltaY < 20:
			if Input.is_key_pressed(KEY_V):		
				e.queue_free()	
		elif(deltaX < 15 && deltaX > 10) && !heading && deltaY < 20:
			if Input.is_key_pressed(KEY_V):	
				e.queue_free()
		elif(deltaX < 11 && deltaX > -11) && deltaY < 20:
			get_tree().change_scene_to_file("res://scenes/start_screen.tscn")
				
				
	

func gimmegimmegimmeyourblocks(w,layer):
	var tilemap = get_parent().get_node("TileMap")
	var tilemapcoords = tilemap.local_to_map(global_position)
	tilemapcoords.x -= w
	var atlascoords = tilemap.get_cell_atlas_coords(layer,tilemapcoords)
	var source_id = tilemap.get_cell_source_id(layer,tilemapcoords)
	return {"coords":tilemapcoords,"a_coords":atlascoords,"s_id":source_id}
			
func _physics_process(delta):
	
	var attack = Input.is_action_pressed("attack_btn")
	if attack:
		$AudioStreamSword.play()
		$AnimatedSprite2D.play("attack")

		
		
	enemy()
	
	if start:
		velocity.x = 100
		$AnimatedSprite2D.play("default")
		start = false
	else:
		var direction = 0
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
			if !attack:
				$AnimatedSprite2D.flip_h = false
				$AnimatedSprite2D.play("default")
			velocity.x = ACCELERATION*delta + velocity.x - FRICTION*velocity.x
		elif direction < 0 and is_on_floor():
			velocity.x = -ACCELERATION*delta + velocity.x - FRICTION*velocity.x
			if !attack:
				$AnimatedSprite2D.flip_h = true
				$AnimatedSprite2D.play("default")
		elif is_on_floor():
			velocity.x = velocity.x - FRICTION*1.8*velocity.x
			if !attack:
				$AnimatedSprite2D.play("idle")
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
	if body.name == "PlayerLink":
		get_node("Camera2D/Draußen").visible = true
		get_node("Camera2D/Dungeon").visible = false
		$AudioStreamDungeon.stop()
		$AudioStreamMusic.play()
