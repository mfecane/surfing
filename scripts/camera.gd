extends Node3D

@onready var surfer: Surfer = $"../Surfer_placeholder"
@onready var board = $"../board_grp"

func updateCameraSide():
	if transform.basis.z.dot(board.transform.basis.z) < 0:
		Global.cameraSide = Side.RIGHT
	else: 
		Global.cameraSide = Side.LEFT

func _physics_process(delta):
	updateCameraSide()
	transform  = transform.interpolate_with(surfer.transform, delta * 2.0)
