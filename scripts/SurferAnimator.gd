class_name SurferAnimator

extends Node

@onready var skeleton = $"../Armature/Skeleton3D"
@onready var animationTree = $"../AnimationTree"
@onready var animationPlayback = animationTree.get("parameters/playback")

var jibingNode
var tackingNode

func _ready():
	var stateMachine = animationTree.tree_root
	jibingNode = stateMachine.get_node('jibing')
	tackingNode = stateMachine.get_node('tacking')

func handleSurfState():
	if Global.surferSide == Side.LEFT:
		animationPlayback.travel('riding_left_new')
	else:
		animationPlayback.travel('riding_right_new')

func handleTackingState():
	if Global.surferSide == Side.LEFT:
		tackingNode.play_mode = 0
	else:
		tackingNode.play_mode = 1
	animationPlayback.travel('tacking')

func handleJibingState():
	if Global.surferSide == Side.LEFT:
		jibingNode.play_mode = 1
	else:
		jibingNode.play_mode = 0
	animationPlayback.travel('jibing')
