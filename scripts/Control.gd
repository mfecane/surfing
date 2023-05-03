extends Node

@onready var sailControl = $"/root/world/SailAttachment/SailControl"

const SENSITYVITY = Vector2(0.0001, 0.0005)

func _ready():
	sailControl.rotation_order = EulerOrder.EULER_ORDER_XZY
	sailControl.rotation.y = PI / 3
	
func _unhandled_input(event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()

	if event is InputEventMouseMotion:
		var deltaYaw = event.relative.y * SENSITYVITY.y * Global.cameraSide
		var deltaPitch = event.relative.x * SENSITYVITY.x * Global.cameraSide

		sailControl.rotation.y -= deltaYaw
		sailControl.rotation.z += deltaPitch

