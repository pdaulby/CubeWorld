class_name CameraClick extends Camera3D

@export var highlighter: BlockHighlighter

func _input(event: InputEvent):
	_handle_hover(event)

func _handle_hover(event: InputEvent):
	if !event is InputEventMouseMotion:
		return
	var result = raycast_mouse(event.position, [])
	if result.is_empty():
		highlighter.unhighlight()
	elif result.collider is GroundCube:
		highlighter.highlight_top(result.collider.position)
	else:
		highlighter.unhighlight()

# handle ui elements https://zhifez-lee.medium.com/godot-4-0-block-raycast-when-clicking-on-ui-b12bb4a1fbe0
func raycast_mouse(screenPosition: Vector2, exclude: Array[RID]):
	var from = project_ray_origin(screenPosition)
	var to = from + project_ray_normal(screenPosition) * 1000.0
 
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.exclude = exclude
	return space_state.intersect_ray(query)

func handle_click(event: InputEvent, exclude: Array[RID] = [])->Dictionary:
	if !(event is InputEventMouseButton and event.pressed and event.button_index == 1):
		return {}
	var result = raycast_mouse(event.position, exclude)
	if (result.is_empty()):
		return {}
	highlighter.unhighlight()
	return result
	
func _process(delta):
	pass
