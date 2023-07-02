extends Node
var coins = 0
var lives = 3
var Level1 = preload("res://scenes/Level1.tscn")
var Level2 = preload("res://scenes/Level2.tscn")
var Start = preload("res://scenes/start_screen.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(Start.instantiate())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func cointer():
	coins += 1
	print("Godot Hurensohn")
	var coinlabel = get_child(0).get_node("CanvasLayer/Label")
	coinlabel.text = str("Coins: ", coins)
	
func death():
	lives -= 1
	print(lives)
	if lives == 0:
		get_child(0).queue_free()
		add_child(Start.instantiate())
	else:
		get_child(0).queue_free()
		add_child(Level1.instantiate())
		print(coins, lives)

func init_level1():
	get_child(0).queue_free()
	add_child(Level1.instantiate())
	var coinlabel = get_child(0).get_node("CanvasLayer/Label")
	coinlabel.text = str("Coins: ", coins)
	var livelabel = get_child(0).get_node("CanvasLayer/Lives")
	livelabel.text = str("Lives: ", lives)
	
func init_level2():
	get_child(0).queue_free()
	add_child(Level2.instantiate())
	var coinlabel = get_child(0).get_node("CanvasLayer/Label")
	coinlabel.text = str("Coins: ", coins)
	var livelabel = get_child(0).get_node("CanvasLayer/Lives")
	livelabel.text = str("Lives: ", lives)
