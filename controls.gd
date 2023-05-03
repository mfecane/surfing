extends Node3D

@onready var boardPivotNode = $board_grp

@onready var gui = $gui
@onready var cameraPivot = $CameraPivot
@onready var water = $Water

@onready var debug = $Debug
@onready var balanceControl = $gui/BalanceControl
@onready var surferNode = $Surfer_placeholder

@onready var physics = $Physics

const SENSITYVITY = Vector2(0.0001, 0.0005)

var fallTarget = Vector3(0.0, 0.0, 0.0)

var controllable = true
var yaw = PI/3
var pitch = 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	physics.disabled = false
	gui.fail = false

func _process(_delta):
	gui.windDirection = physics.windDirection
	gui.balancePoint = physics.boardKinematics.balancePoint
	
	# if controllable and balancePoint > 1.0:
	# 	controllable = false
	# 	$gui.fail = true
	# 	fallTarget = Vector3(-PI/2, 0.0, 0.0)

	# if controllable and balancePoint < -1.0:
	# 	controllable = false
	# 	$gui.fail = true
	# 	fallTarget = Vector3(PI/2, 0.0, 0.0)
