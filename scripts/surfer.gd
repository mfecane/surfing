extends Node3D

class_name Surfer

@onready var leftFront = $"../board_grp/left_front"
@onready var leftBack = $"../board_grp/left_back"
@onready var rightFront = $"../board_grp/right_front"
@onready var rightBack = $"../board_grp/right_back"
@onready var startPosition = $"/root/world/SailAttachment/SailControl/sail_grp/startPosition"

@onready var physics = $"/root/world/Physics"
@onready var boardPivotNode = $"../board_grp"

var stateMachine = StateMachine.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(_delta):
	if signf(boardPivotNode.transform.basis.z.dot(physics.windDirection)) > 0:
		Global.windSide = Side.LEFT
	else:
		Global.windSide = Side.RIGHT
