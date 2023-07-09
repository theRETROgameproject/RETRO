extends CharacterBody2D

func _ready():
	get_child(2).get_child(0).fade_in()

func _physics_process(delta):
	pass
