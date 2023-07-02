extends Node
var coins = 0
var Level2 = preload("res://scenes/Level2.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func cointer():
	coins += 1
	var coinlabel = get_child(0).get_node("CanvasLayer/Label")
	coinlabel.text = str("Coins: ", coins)

func level2():
	get_child(0).queue_free()
	var next_level = Level2.instantiate()
	add_child(next_level)
