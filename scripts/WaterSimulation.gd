extends Node3D

@onready var cr = $Simulation/ColorRect
@onready var water = $Water

func _ready():
	var simulationTexture = $Simulation.get_texture()
	var collisionTexture = $Collision.get_texture()
	
	cr.material.set_shader_parameter('sim_tex', simulationTexture)
	cr.material.set_shader_parameter('col_tex', collisionTexture)

	water.mesh.surface_get_material(0).set_shader_parameter('simulationTexture', simulationTexture)
	#water.mesh.surface_get_material(0).set_shader_parameter('simulation2', simulationTexture)
