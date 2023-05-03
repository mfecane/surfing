extends Node

class_name Physics

@onready var sailPivotNode = $"/root/world/SailAttachment/SailControl/sail_grp"
@onready var sailCenterNode = $"/root/world/SailAttachment/SailControl/sail_grp/sail_center"
@onready var boardPivotNode = $"../board_grp"
@onready var boardCenterNode = $"../board_grp/board_center"
@onready var surferNode = $"../Surfer_placeholder"
@onready var water = $"../Water"

@onready var sailAttachment = $"/root/world/SailAttachment"

@export var disabled: bool = true

var windDirection: Vector3 = Vector3(0.0, 0.0, 1.0)
var windForce: float = 1.0
var attachSail: bool = true

class BoardKinematics:
	var boardPosition: Vector3 = Vector3(0.0, 0.0, 0.0)
	var boardSpeed: Vector3 = Vector3(0.0, 0.0, 0.0)
	var boardRotation: float = 0.0
	var boardRotationSpeed: float = 0.0
	var balancePoint: float = 0.0
	var balancePointChangeSpeed: float = 0.0

var boardKinematics: BoardKinematics

class BoardPhysics:
	var windForce: Vector3 = Vector3(0.0, 0.0, 0.0)
	var windMomentumY: float = 0.0
	var windMomentumX: float = 0.0
	var sailWeightMomentumX: float = 0.0
	var surferWeightMomentumX: float = 0.0
	var controlMomentumX: float = 0.0
	var userControlMomentumX: float = 0.0
	var rotationMomentumY: float = 0.0
	var drag: Vector3 = Vector3(0.0, 0.0, 0.0)

var boardPhysics: BoardPhysics

func _init():
	boardKinematics = BoardKinematics.new()
	boardPhysics = BoardPhysics.new()

func applyRotationMomentumY(value: float):
	boardPhysics.rotationMomentumY += value

func calculateWindForce():
	# TODO calculate surface of sail
	# TODO improve this calculation
	var sailNormal: Vector3 = sailPivotNode.global_transform.basis.z
	var windForceMag: float = windDirection.dot(sailNormal)
	boardPhysics.windForce = windForceMag * abs(windForceMag) * sailNormal

func updateBoardPhysics(delta):
	var sailCenter: Vector3 = sailCenterNode.global_transform.origin
	var boardCenter: Vector3 = boardCenterNode.global_transform.origin
	var boardDirection: Vector3 = boardPivotNode.transform.basis.x

	calculateWindForce()
	var leverage: Vector3 = sailCenterNode.global_transform.origin - boardCenter
	boardPhysics.windMomentumY = -boardPhysics.windForce.cross(leverage).dot(Vector3.UP) * 2.0
	boardPhysics.windMomentumX = \
		boardPhysics.windForce.cross(sailCenterNode.global_transform.origin).dot(boardDirection)
	
	var sailWeight = 3.0
	var sailWeightMomentum: Vector3 = (-Vector3.UP * sailWeight).cross(sailCenter)
	boardPhysics.sailWeightMomentumX = sailWeightMomentum.dot(boardDirection)
	
	var surferWeight = 3.0
	var surferCenter: Vector3 = surferNode.global_transform.origin
	var surferWeightMomentum: Vector3 = (-Vector3.UP * surferWeight).cross(surferCenter)
	boardPhysics.surferWeightMomentumX = surferWeightMomentum.dot(boardDirection)

# TODO clamp by max values
# auto feedback loop
	boardPhysics.controlMomentumX = lerp(boardPhysics.controlMomentumX, -boardKinematics.balancePoint * 4.0, delta * 0.2)
# user input
	boardPhysics.controlMomentumX += boardPhysics.userControlMomentumX * delta
	boardPhysics.controlMomentumX = clampf(boardPhysics.controlMomentumX, -2.0, 4.0)

	var alongComponent = boardDirection * boardKinematics.boardSpeed.dot(boardDirection)
	var acrossComponent = boardKinematics.boardSpeed - alongComponent
	boardPhysics.drag = alongComponent * 0.5 + acrossComponent * 1.0

	# slowly remove rotaton control momentum
	# user rotation
	boardPhysics.rotationMomentumY = lerp(boardPhysics.rotationMomentumY, 0.0, delta * 10.0)

func updateBalance(_delta):
	pass

func applyBoardPhysics(delta):
	var boardDirection: Vector3 = boardPivotNode.transform.basis.x
	
	boardKinematics.boardRotationSpeed += (boardPhysics.windMomentumY * 0.2 - \
		boardKinematics.boardRotationSpeed * 0.2 + boardPhysics.rotationMomentumY) * delta
	boardKinematics.balancePointChangeSpeed = (boardPhysics.windMomentumX + \
		boardPhysics.sailWeightMomentumX + boardPhysics.surferWeightMomentumX + \
		boardPhysics.controlMomentumX) * 8.0 * delta
	boardKinematics.boardSpeed += (0.7 * boardDirection * \
		boardPhysics.windForce.dot(boardDirection) - boardPhysics.drag) * delta

func updateBoardKinematics(delta):
	boardKinematics.boardRotation += boardKinematics.boardRotationSpeed * delta
	boardKinematics.boardPosition += boardKinematics.boardSpeed * delta
	boardKinematics.balancePoint += boardKinematics.balancePointChangeSpeed * delta

func updateBoardPosition(delta):
	boardPivotNode.rotation = Vector3(0.0, boardKinematics.boardRotation, 0.0)

	if attachSail:
		# closest by PI
		var pis = roundf((sailAttachment.rotation.y - boardPivotNode.rotation.y) / PI)
		var newRotation = Vector3(boardPivotNode.rotation)
		newRotation.y += pis * PI
		sailAttachment.rotation = sailAttachment.rotation.lerp(newRotation, delta * 2.0)

func _physics_process(delta):
	if disabled:
		pass
	updateBoardPhysics(delta)
	applyBoardPhysics(delta)
	updateBoardKinematics(delta)
	updateBoardPosition(delta)
