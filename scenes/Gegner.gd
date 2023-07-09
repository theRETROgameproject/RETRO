extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var dead = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var startpos = position.x

func gimmegimmegimmeyourblocks(w,layer):
	var tilemap = get_parent().get_parent().get_node("TileMap")
	var tilemapcoords = tilemap.local_to_map(global_position)
	tilemapcoords.x -= w
	var atlascoords = tilemap.get_cell_atlas_coords(layer,tilemapcoords)
	var source_id = tilemap.get_cell_source_id(layer,tilemapcoords)
	return {"coords":tilemapcoords,"a_coords":atlascoords,"s_id":source_id}

func enemycoin():
	var tilemap = get_parent().get_parent().get_node("TileMap")
	var tilemapcoords = tilemap.local_to_map(global_position)
	var atlascoords = tilemap.get_cell_atlas_coords(0,tilemapcoords)
	var random = randi_range(0,1)
	tilemap.set_cell(0,tilemapcoords,2,Vector2i(random,random))
		
func anime():
	if dead:
		$AnimatedSprite2D.play("death")
		$AnimatedSprite2D.material.shader = Shader.new()
		remove_child(get_node("CollisionShape2D"))
	elif velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("default")
	elif velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("default")
	elif velocity.x == 0:
		$AnimatedSprite2D.play("idle")

func death():
	dead = true
	await get_tree().create_timer(0.8125).timeout	
	enemycoin()
	queue_free()

func _physics_process(delta):

	
	if $AnimatedSprite2D.animation_finished:
		anime()
	
	var left = gimmegimmegimmeyourblocks(-1,0)
	var right = gimmegimmegimmeyourblocks(1,0)
	
	if is_on_floor() and velocity.x == 0 and !dead:
		if left.s_id != -1:
			velocity.y = -300
			await get_tree().create_timer(0.05).timeout
			velocity.x = 20
		if right.s_id != -1:
			velocity.y = -300
			await get_tree().create_timer(0.05).timeout
			velocity.x = -20
			
	if not is_on_floor() and !dead:
		velocity.y += gravity * delta
		
	var playerXpos = get_parent().get_parent().get_node("PlayerLink").position.x
	var deltaXPlayer = position.x-playerXpos
	var deltaXStart = position.x-startpos
	
	if !Main.dead && !dead:
		if deltaXPlayer > 5 && deltaXPlayer < 150:
			velocity.x = -50
			
		elif deltaXPlayer < -5 && deltaXPlayer > -150: 
			velocity.x = 50
			
		else:
			if deltaXStart > 20:
				velocity.x = -20
				if deltaXStart == 20:
					velocity.x = 20
			elif deltaXStart < -20:
				velocity.x = 20
				if deltaXStart == -20:
					velocity.x = -20
	else:
		velocity.x = 0
		
	
	move_and_slide()
