extends MeshInstance3D

@onready var physics: Physics = $"/root/world/Physics"

var material: ShaderMaterial

func _ready():
	material = self.get_active_material(0)

func _process(_delta):
	var boardPosition = physics.boardKinematics.boardPosition
	material.set_shader_parameter("shift", Vector2(boardPosition.z, boardPosition.x))
