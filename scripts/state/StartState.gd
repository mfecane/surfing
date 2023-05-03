extends State

class_name StartState

@onready var physics = $"/root/world/Physics"
@onready var sailPivotNode = $"/root/world/SailAttachment/SailControl/sail_grp"
@onready var startPosition = $"/root/world/SailAttachment/SailControl/sail_grp/startPosition"
@onready var surfer = $"/root/world/Surfer_placeholder"

func enter():
	physics.attachSail = false
	
func update(delta: float):
	surfer.transform = surfer.transform.interpolate_with(startPosition.global_transform, delta)

	# TODO check this i don't like how it works
	if absf(sailPivotNode.rotation.y - PI/2) > PI/6 + 0.1 || \
		physics.boardKinematics.boardSpeed.length() > 0.06:
		stateMachine.switchState('Riding')

	if Input.is_action_pressed("right"): 
		physics.applyRotationMomentumY(4.0 * delta)
	if Input.is_action_pressed("left"): 
		physics.applyRotationMomentumY(-4.0 * delta)

func exit():
	# we do it two times btw
	physics.attachSail = false
	# we can start in any direction
	Global.surferSide = Global.windSide
