extends Node2D

@onready var wind_meter_grp = $Wind_gui/wind_meter
@onready var suck = $Wind_gui/suck
@onready var balanceControl = $BalanceControl

@export var camera: Camera3D
@export var fail = false

@export var windDirection: Vector3
@export var balancePoint: float = 0.0

func _ready():
	pass
	
func _process(_delta):
	suck.visible = fail
	
	var screenSpaceWind = camera.unproject_position(windDirection) - \
		camera.unproject_position(Vector3(0.0, 0.0, 0.0))
	screenSpaceWind = screenSpaceWind.normalized()
	wind_meter_grp.rotation = atan2(screenSpaceWind.x, -screenSpaceWind.y)
	
	balanceControl.balanceShift = balancePoint
