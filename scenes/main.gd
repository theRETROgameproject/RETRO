extends Node
var coins = 0
var lives = 3

#var current_scene = null
#
## Called when the node enters the scene tree for the first time.
#func _ready():
#	var root = get_tree().root
#	print_debug(root)
#	current_scene = root.get_child(0)
#	print_debug(current_scene)
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
	# print_debug(current_level)
	
#func switch_scene(res_path):
#	current_scene.queue_free()
#	var s = load(res_path)
#	current_scene = s.instantiate()
#	get_tree().root.add_child(current_scene)
#	get_tree().current_scene = current_scene
#	print_debug(current_scene)
	
#func death():
#	lives -= 1
#	print_debug(lives)
#	if lives == 0:
#		switch_scene("res://scenes/start_screen.tscn")
#	else:
#		print(str(get_path_to(current_scene)))
		# if str(get_path_to(current_level)) == "Level1":
		# current_scene.change_scene_to_packed(level_1_scene)
