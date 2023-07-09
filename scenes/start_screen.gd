extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	get_child(2).fade_in()

func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		get_child(2).fade_out()
		await get_tree().create_timer(0.3).timeout
		get_tree().change_scene_to_file("res://scenes/Level1.tscn")

func _on_button_pressed():
	get_child(2).fade_out()
	await get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_file("res://scenes/Level1.tscn")
