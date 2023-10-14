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
	
	if !in_stack_limit(prop.height, prop.block): return
	world.push_block(prop)

func in_stack_limit(height: int, block: Vector3i)->bool:
	var higher_block = block + Vector3i.UP
	if !world.in_bounds(higher_block):
		return true
	if world.get_block(higher_block).type != BLOCK.TYPE.BLOCK:
		return true
	if height <= 1: 
		return false
	return in_stack_limit(height + 1, higher_block)
