extends Button


func _on_pressed():
	get_tree().root.get_child(0).switch_level("res://scenes/Level1.tscn")
	print("lal")
