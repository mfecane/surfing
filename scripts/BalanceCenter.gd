extends Sprite2D

@export var color: Color = Color.WHITE

func _draw():
	draw_circle(Vector2(0.0, 0.0), 40.0, color)
	
func _process(_delta):
	queue_redraw()
