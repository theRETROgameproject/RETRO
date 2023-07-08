extends Node
var coins = 0
var lives = 3

var current_scene = null
var current_level = null


# Called when the node enters the scene tree for the first time.
func _ready():
	var root = get_tree().root
	print_debug(root)
	current_scene = root.get_child(0)
	print_debug(current_scene)
	current_level = current_scene.get_child(0)
	print_debug(current_level)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func cointer():
	coins += 1
	print("Godot Hurensohn")
	var coinlabel = get_child(0).get_node("CanvasLayer/Label")
	coinlabel.text = "Coins: " + str(coins)
	
func switch_level(res_path):
	current_level.queue_free()
	var l = load(res_path)
	current_level = l.instantiate()
	current_scene.add_child(current_level)
	# get_tree().current_level = current_level
	print_debug(current_level)
	
func death():
	lives -= 1
	print_debug(lives)
	if lives == 0:
		switch_level("res://scenes/start_screen.tscn")
	else:
		# switch_level("res://scenes/" + str(get_path_to(current_level)) + ".tscn")
		switch_level("res://scenes/Level1.tscn")
		var test = get_path_to(current_level)
		print(test)
