extends Camera3D

func _ready():
	pass # Replace with function body.

# handle ui elements https://zhifez-lee.medium.com/godot-4-0-block-raycast-when-clicking-on-ui-b12bb4a1fbe0
func _input(event: InputEvent):
	if !(event is InputEventMouseButton and event.pressed and event.button_index == 1):
		return
	var from = project_ray_origin(event.position)
	var to = from + project_ray_normal(event.position) * 1000.0
 
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = space_state.intersect_ray(query)
	if (result.is_empty()):
		return
	
	handle_click(result)
	
func handle_click(result):
	print_debug(result.collider.position)
	if result.collider is GroundCube:
		print("groundCube")
		result.collider.highlight()
	
func _process(delta):
	pass
