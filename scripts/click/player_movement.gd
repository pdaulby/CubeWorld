class_name PlayerMovement extends Node

var camera: CameraClick
var enabled: bool = true
var player: Player
var world: World
var path_finder = PathFinder.new()

func _ready():
	camera = get_node("/root/World/Camera3D")
	world = get_node("/root/World")
	player = get_parent() as Player
	print_debug(player)

func _input(event):
	if !enabled:
		return
	var result = camera.handle_click(event, [])
	if result.is_empty():
		return
	if !result.collider is GroundCube:
		return
	var cube = result.collider as GroundCube
	print_debug(player)
	var playerXZ = Vector2i(player.position.x, player.position.z)
	var cubeXZ = Vector2i(cube.position.x, cube.position.z)
	var path = path_finder.find_path(world.to_2d(), world.bounds, playerXZ, cubeXZ)
	print_debug(path.size())
	print_debug(path)
