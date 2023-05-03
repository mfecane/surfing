extends State

class_name RidingState

@onready var physics = $"/root/world/Physics"
@onready var surfer = $"/root/world/Surfer_placeholder"
@onready var sailPivotNode = $"/root/world/SailAttachment/SailControl"
@onready var leftFront = $"/root/world/board_grp/left_front"
@onready var rightFront = $"/root/world/board_grp/right_front"
@onready var board = $"/root/world/board_grp"

func enter(): # override
	physics.attachSail = true
	
func update(delta: float):
	physics.boardPhysics.userControlMomentumX = 0.0
	if Input.is_action_pressed("forward"): 
		physics.boardPhysics.userControlMomentumX = -6.0
	elif Input.is_action_pressed("back"): 
		physics.boardPhysics.userControlMomentumX = 6.0

	var surferPosition
	if Global.surferSide == Side.LEFT:
		surferPosition = leftFront.global_transform
	else:
		surferPosition = rightFront.global_transform
	surfer.transform = surfer.transform.interpolate_with(surferPosition, delta)
	
	# TODO fix this shit
	if absf(fmod(sailPivotNode.rotation.y, PI/2)) < 0.1 && \
		physics.boardKinematics.boardSpeed.length() < 0.05:
		stateMachine.switchState('Start')
		return
	
	if board.transform.basis.x.dot(physics.windDirection) < 0 && \
		Global.surferSide != Global.windSide:
		stateMachine.switchState('Tacking')
		return
	
	if board.transform.basis.x.dot(physics.windDirection) > 0 && \
		Global.surferSide != Global.windSide:
		stateMachine.switchState('Jibing')

func exit(): # override
	physics.attachSail = true
