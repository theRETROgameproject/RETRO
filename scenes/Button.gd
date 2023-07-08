extends Button


func _on_pressed():
	get_tree().root.get_child(0).init_level1()
	print("lal")
