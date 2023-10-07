extends Camera3D

@export var highlighter: BlockHighlighter

func _ready():
	pass # Replace with function body.

# handle ui elements https://zhifez-lee.medium.com/godot-4-0-block-raycast-when-clicking-on-ui-b12bb4a1fbe0
func _input(event: InputEvent):
	if (event is InputEventMouseMotion):
		var result = _raycast_mouse(event.position)
		if result.is_empty():
			highlighter.unhighlight()
		elif result.collider is GroundCube:
			highlighter.highlight_top(result.collider.position)
		else:
			highlighter.unhighlight()
	if !(event is InputEventMouseButton and event.pressed and event.button_index == 1):
		return
	var result = _raycast_mouse(event.position)
	if (result.is_empty()):
		return
	
	handle_click(result)

func _raycast_mouse(screenPosition: Vector2):
	var from = project_ray_origin(screenPosition)
	var to = from + project_ray_normal(screenPosition) * 1000.0
 
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	return space_state.intersect_ray(query)

func handle_click(result):
	print_debug(result.collider.position)
	if result.collider is GroundCube:
		print("groundCube")
	
func _process(delta):
	pass
