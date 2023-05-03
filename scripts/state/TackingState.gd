extends State

class_name TackingState

@onready var physics = $"/root/world/Physics"
@onready var surfer = $"/root/world/Surfer_placeholder"
@onready var leftFront = $"/root/world/board_grp/left_front"
@onready var rightFront = $"/root/world/board_grp/right_front"
@onready var tackingPosition = $"/root/world/board_grp/tacking_pos"
@onready var board = $"/root/world/board_grp"
@onready var sailControl = $"/root/world/SailAttachment/SailControl"

const ADJUST_SAIL_ANGLE = PI / 6.0

var process: float = 0.0
var newSurferPosition: Node3D
var startSailAngle = 0.0

func enter(): # override
	Global.lockControls = true

	process = 0.0
	startSailAngle = sailControl.rotation.y

	assert(Global.surferSide != Global.windSide)
	Global.surferSide = Global.windSide
	
	if Global.surferSide == Side.LEFT:
		newSurferPosition = leftFront
	else:
		newSurferPosition = rightFront
	
func update(delta: float):
	#? switch to start position if failed
	# speed is too low
	
	if process < 0.5:
		surfer.transform = surfer.transform.interpolate_with(tackingPosition.global_transform, process * 2.0)
	else:
		surfer.transform = surfer.transform.interpolate_with(newSurferPosition.global_transform, (process - 0.5) * 2.0)
		
	sailControl.rotation.y = startSailAngle + process * ADJUST_SAIL_ANGLE * Global.surferSide

	process += delta * 2.0

	if process > 1.0:
		stateMachine.switchState('Riding')

func exit(): # override
	Global.lockControls = false
