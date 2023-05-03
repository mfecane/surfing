extends Node2D

@export var camera: Camera3D 

var pairs = []

func line(id: String, start: Vector3, end: Vector3, color: Color = Color.CORAL):
	var found = false
	for index in range(pairs.size()):
		if pairs[index][0] == id:
			pairs[index] = [id, start, end, color]
			found = true
	if not found:
		pairs.append([id, start, end, color])
	
func axis():
	line('x_axis', Vector3(0.0, 0.0, 0.0), Vector3(1.0, 0.0, 0.0), Color.RED)
	line('y_axis', Vector3(0.0, 0.0, 0.0), Vector3(0.0, 1.0, 0.0), Color.GREEN)
	line('z_axis', Vector3(0.0, 0.0, 0.0), Vector3(0.0, 0.0, 1.0), Color.BLUE)

# Called when the node enters the scene tree for the first time.
func _ready():
#	axis()
	pass

func _process(_delta):
	queue_redraw()

func _draw():
	for x in pairs:
		var start = x[1] as Vector3
		var end = x[2] as Vector3
		var color = x[3] as Color
		draw_line(camera.unproject_position(start), camera.unproject_position(end), color, 2)
