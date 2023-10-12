class_name PlayerMovement extends Node

@export var speed: int = 4
var camera: CameraClick
var enabled: bool = true
var player: Player
var world: World
var path_finder = PathFinder.new()
var current_path = []


func _ready():
	camera = get_node("/root/World/Camera3D")
	world = get_node("/root/World")
	player = get_parent() as Player

func _input(event):
	if current_path.size() > 0 || !enabled: return
	var result = camera.handle_click(event, [])
	if result.is_empty(): return
	if !result.collider is GroundCube: return
	var cube = result.collider as GroundCube
	var playerXZ = Vector2i(player.position.x, player.position.z)
	var cubeXZ = Vector2i(cube.position.x, cube.position.z)
	var path = path_finder.find_path(world.to_2d(), world.bounds, playerXZ, cubeXZ)
	current_path = path.map(func(h:HeightBlock): return Vector3i(h.xz.x, h.height, h.xz.y))
	if current_path.is_empty(): return
	world.move_from_to(player.position, current_path[current_path.size()-1])

func _process(delta):
	if current_path.size() == 0: return
	player.position = player.position.move_toward(current_path[0], delta*speed)
	if player.position.distance_to(current_path[0]) < 0.01:
		player.position = current_path[0]
		current_path.remove_at(0)
