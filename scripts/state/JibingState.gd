extends State

class_name JibingState

@onready var physics = $"/root/world/Physics"
@onready var surfer = $"/root/world/Surfer_placeholder"
@onready var leftFront = $"/root/world/board_grp/left_front"
@onready var rightFront = $"/root/world/board_grp/right_front"
@onready var jibingPosition = $"/root/world/board_grp/jibing_pos"
@onready var board = $"/root/world/board_grp"
@onready var sailControl = $"/root/world/SailAttachment/SailControl"

const FLIP_SAIL_ANGLE = 3.0 * PI / 2.0

var process: float = 0.0
var newSurferPosition: Node3D
var startSailAngle = 0.0

func enter(): # override
	Global.lockControls = true
	process = 0.0
	assert(Global.surferSide != Global.windSide)
	Global.surferSide = Global.windSide
	startSailAngle = sailControl.rotation.y
	if Global.surferSide == Side.LEFT:
		newSurferPosition = leftFront
	else:
		newSurferPosition = rightFront
	
func update(delta: float):
	#? switch to start position if failed
	# speed is too low
	
	if process < 0.5:
		surfer.transform = surfer.transform.interpolate_with(jibingPosition.global_transform, process * 2.0)
	else:
		surfer.transform = surfer.transform.interpolate_with(newSurferPosition.global_transform, (process - 0.5) * 2.0)
		
	sailControl.rotation.y = startSailAngle - process * FLIP_SAIL_ANGLE * Global.surferSide
	process += delta * 2.0

	if process > 1.0:
		stateMachine.switchState('Riding')

func exit(): # override
	Global.lockControls = false
