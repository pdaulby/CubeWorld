class_name BlockPusher extends Node

var world: World
var camera: CameraClick
var player: Player
var active = false

func _ready():
	player = get_parent() as Player
	world = get_node("/root/World")
	camera = get_node("/root/World/Camera3D")

func _input(event):
	if !active || !player.active: return
	var result = camera.handle_click(event, [])
	if result.is_empty(): return
	if !result.collider is GroundCube: return
	var cube: GroundCube = result.collider
	if cube.position.distance_to(player.position) > 1: return
	var prop = PushProp.new(cube.position).from(player.position)
	world.push_block(prop)
