extends Node2D

@export var balanceShift: float = 0.0

@onready var circle = $ControlPivot/Circle

const PIXEL_SCALE = 100.0
const THRESHOLD = 0.7

var color = Color.WHITE

func _process(_delta):
	var balanceShiftLocal = clamp(balanceShift, -1.0, 1.0)
	circle.position.y = balanceShiftLocal * PIXEL_SCALE
	var mapped = Lib.map(absf(balanceShiftLocal), 1.0, THRESHOLD, 0.0, 1.0, true)
	if mapped < 0.0:
		mapped = 0.0
	if mapped > 1.0:
		mapped = 1.0
	color.g = mapped
	color.b = mapped
	circle.color = color
