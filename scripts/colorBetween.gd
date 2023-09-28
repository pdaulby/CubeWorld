extends MeshInstance3D

@export var colorA: Color = Color.SADDLE_BROWN
@export var colorB: Color = Color.LIGHT_GREEN

func _ready():
	var material = get_active_material(0).duplicate()
	material.albedo_color = colorA.lerp(colorB, randf())
	set_surface_override_material(0, material)
