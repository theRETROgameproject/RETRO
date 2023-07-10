extends CanvasLayer
		
func fade_in():
	$AnimationPlayer.play("fade_to_normal")

func fade_out():
	$AnimationPlayer.play("fade_to_black")

func you_died():
	$AnimationPlayer.play("you_dies")

func game_over():
	$AnimationPlayer.play("game_over")
func completed():
	$AnimationPlayer.play("completed")
func blitz():
	$AnimationPlayer.play("Blitz")
