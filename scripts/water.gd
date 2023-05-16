extends MeshInstance3D

@onready var physics: Physics = $"/root/world/Physics"
@onready var floor = $"floor"

var material: ShaderMaterial
var sandMaterial

func _ready():
	material = self.get_active_material(0)
	sandMaterial = floor.get_active_material(0)

func _process(_delta):
	var boardPosition = physics.boardKinematics.boardPosition
	material.set_shader_parameter("shift", Vector2(boardPosition.z, boardPosition.x))
	sandMaterial.uv1_offset = Vector3(boardPosition.x, boardPosition.z, 0.0)
