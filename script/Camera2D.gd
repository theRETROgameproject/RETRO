extends Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var PlayerPosition = get_parent().get_node("PlayerMario").position
	var PlayerVelocity = get_parent().get_node("PlayerMario").velocity
	
	position.x = PlayerPosition[0]-PlayerVelocity[0]*0.2
	position.y = PlayerPosition[1]-80+PlayerVelocity[1]*0.1
