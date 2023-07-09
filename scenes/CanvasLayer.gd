extends CanvasLayer
		
func fade_in():
	$AnimationPlayer.play("fade_to_normal")

func fade_out():
	$AnimationPlayer.play("fade_to_black")

func game_over():
	$AnimationPlayer.play("game_over")
