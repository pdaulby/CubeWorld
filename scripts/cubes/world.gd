class_name World extends Node3D

var block_scene: PackedScene = preload("res://scenes/ground_cube.tscn")
var player_scene: PackedScene = preload("res://scenes/player.tscn")
var cubes_node: Node
var characters_node: Node

var bounds: Vector3i
var state: Array = []

func _ready():
	cubes_node = get_node("Environment/Cubes")
	characters_node = get_node("Environment/Characters")
	call_deferred("_init_world")

func _init_world():
	_construct_world(WorldSave.new())

func _construct_world(save: WorldSave):
	_create_empty_state(save)
	var x = 0
	for xyz in save.world:
		var y = 0
		for yz in xyz:
			var z = 0
			for zType in yz:
				_create_item(zType,x,y,z)
				z = z + 1
			y = y + 1
		x = x + 1

func _create_item(type: BLOCK.TYPE, x: int, y: int, z: int):
	match type:
		BLOCK.TYPE.AIR:
			return
		BLOCK.TYPE.BLOCK:
			var node = _create_cube(Vector3(x,y,z))
			state[x][y][z]=StateBlock.new(type, node)
		BLOCK.TYPE.PLAYER:
			var node = _create_player(Vector3(x,y,z))
			state[x][y][z]=StateBlock.new(type, node)

func _create_cube(cubePosition: Vector3): 
	var cube = block_scene.instantiate() as Node3D
	cube.position = cubePosition
	
	cubes_node.add_child(cube)
	return cube

func _create_player(cubePosition: Vector3): 
	var cube = player_scene.instantiate() as Node3D
	cube.position = cubePosition
	characters_node.add_child(cube)
	return cube

func _create_empty_state(save: WorldSave):
	bounds = save.bounds
	state.resize(bounds.x)
	for x in bounds.x:
		state[x] = []
		state[x].resize(bounds.y)
		for y in bounds.y:
			state[x][y] = []
			state[x][y].resize(bounds.z)
			for z in bounds.z:
				state[x][y][z] = StateBlock.new(BLOCK.TYPE.AIR, null)

func to_2d():
	var grid = []
	grid.resize(bounds.x)
	for x in bounds.x:
		grid[x] = []
		grid[x].resize(bounds.z)
		for z in bounds.z:
			grid[x][z] = _get_height(x, z)
	return grid

func _get_height(x, z) -> HeightBlock:
	for y in bounds.y:
		if (state[x][y][z].type != BLOCK.TYPE.BLOCK):
			var hb = HeightBlock.new(y, Vector2i(x,z), state[x][y][z])
			if y == 0: hb.blocked = true
			return hb
	var hb = HeightBlock.new(bounds.y, Vector2i(x,z), StateBlock.new(BLOCK.TYPE.AIR, null))
	hb.blocked = true
	return hb

func move_from_to(from: Vector3i, to: Vector3i):
	var fromBlock = state[from.x][from.y][from.z]
	var toBlock = state[to.x][to.y][to.z]
	if toBlock.type != BLOCK.TYPE.AIR: assert(false, "oh fukfukfuk")
	state[to.x][to.y][to.z] = fromBlock
	state[from.x][from.y][from.z] = StateBlock.new(BLOCK.TYPE.AIR, null)
	# figure out if i need to duplicate the locations more

func push_block(prop: PushProp):
	if !prop.is_valid(): 
		print_debug("invalid")
		return
	var b = prop.block
	var dist = prop.distance
	var next = prop.block + prop.direction
	var path = [prop.block]
	while dist > 0 && in_bounds(next): 
		var next_block = get_block(next)
		if next_block.type == BLOCK.TYPE.BLOCK:
			break
		path.append(next)
		next = next + prop.direction
		dist = dist - 1
	print_debug(path)

func in_bounds(v: Vector3i): 
	if v.x < 0 || v.y < 0 || v.z < 0: return false
	return v.x < bounds.x && v.y < bounds.y && v.z < bounds.z
func get_block(v: Vector3i) -> StateBlock:
	return state[v.x][v.y][v.z]
