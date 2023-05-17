extends Node3D

@onready var physics: Physics = $"/root/world/Physics"
@onready var cr = $Simulation/ColorRect
@onready var water = $Water

var simulationRectMaterial
var waterMaterial

func _ready():
	var simulationTexture = $Simulation.get_texture()
	var collisionTexture = $Collision.get_texture()
	
	
	simulationRectMaterial = cr.material
	simulationRectMaterial.set_shader_parameter('simultationTexture', simulationTexture)
	simulationRectMaterial.set_shader_parameter('collisionTexture', collisionTexture)

	waterMaterial = water.mesh.surface_get_material(0)

	waterMaterial.set_shader_parameter('simulationTexture', simulationTexture)
	#water.mesh.surface_get_material(0).set_shader_parameter('simulation2', simulationTexture)

func _process(delta):
	var boardSpeed = physics.boardKinematics.boardSpeed
	var boardPosition = physics.boardKinematics.boardPosition
	simulationRectMaterial.set_shader_parameter('shift', Vector2(boardSpeed.x * 0.01, boardSpeed.z * 0.01))
	waterMaterial.set_shader_parameter("shift", Vector2(boardPosition.x, boardPosition.z))
