class_name World extends Node3D

var push_speed = 10
var block_scene: PackedScene = preload("res://scenes/ground_cube.tscn")
var player_scene: PackedScene = preload("res://scenes/player.tscn")
var enemy_scene: PackedScene = preload("res://scenes/enemy.tscn")
var cubes_node: Node
var characters_node: Node
var enemies_node: Node

var bounds: Vector3i
var state: Array = []
var block_path: Array[Vector3i] = []

var processing: bool = false

func _ready():
	cubes_node = get_node("Environment/Cubes")
	characters_node = get_node("Environment/Characters")
	enemies_node = get_node("Environment/Enemies")
	call_deferred("_init_world")

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
		if state[x][y][z].type != BLOCK.TYPE.BLOCK:
			var hb = HeightBlock.new(y, Vector2i(x,z), state[x][y][z])
			if y == 0:
				hb.blocked = true
			if state[x][y][z].type != BLOCK.TYPE.AIR:
				hb.blocked = true 
				#TODO smarter handling of walking through other units (maybe)
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
	var _path: Array[Vector3i] = [prop.block]
	while dist > 0 && in_bounds(next): 
		var next_block = get_block(next)
		if next_block.type == BLOCK.TYPE.BLOCK:
			break
		_path.append(next)
		next = next + prop.direction
		dist = dist - 1
	if _path.size() <= 1: return
	block_path = _path
	processing = true

func _process(delta):
	if block_path.size() == 0: return
	print(block_path)
	var stateBlock = get_block(block_path[0])
	if stateBlock.type != BLOCK.TYPE.BLOCK:
		assert(false, "currently only designed to push blocks")
	
	var froms: Array[Vector3i] = [block_path[0]]
	var tos: Array[Vector3i] = [block_path[1]]
	var nodes: Array[Node3D] = [stateBlock.node]
	
	var above = block_path[0] + Vector3i.UP
	while in_bounds(above) && get_block(above).type != BLOCK.TYPE.AIR:
		froms.append(Util.last(froms) + Vector3i.UP)
		tos.append(Util.last(tos) + Vector3i.UP)
		nodes.append(get_block(Util.last(froms)).node)
		above = above + Vector3i.UP
	
	for i in froms.size():
		nodes[i].position = nodes[i].position.move_toward(tos[i], delta*push_speed)
	
	if nodes[0].position.distance_to(tos[0]) > 0.01:
		return
	
	for i in froms.size():
		nodes[i].position = tos[i]
		block_smash(tos[i])
		move_from_to(froms[i], tos[i])
	
	block_path.remove_at(0)
	if block_path.size() != 1: 
		return
	var below = Vector3i(block_path[0].x, block_path[0].y-1, block_path[0].z)
	if !in_bounds(below) || get_block(below).type == BLOCK.TYPE.BLOCK:
		block_path = []
		print_debug("nograv")
		processing = false
		return
	print_debug("grav")
	# gravity drop
	var prop = PushProp.new(block_path[0])
	prop.direction = Vector3i(0,-1,0)
	prop.distance = 1
	prop.height = bounds.y - block_path[0].y - 1
	push_block(prop)

func block_smash(v: Vector3i):
	var block = get_block(v)
	
	if block.type == BLOCK.TYPE.PLAYER || block.type == BLOCK.TYPE.ENEMY:
		block.node.kill()
		state[v.x][v.y][v.z] = StateBlock.Air()

func in_bounds(v: Vector3i): 
	if v.x < 0 || v.y < 0 || v.z < 0: return false
	return v.x < bounds.x && v.y < bounds.y && v.z < bounds.z
	
func get_block(v: Vector3i) -> StateBlock:
	return state[v.x][v.y][v.z]


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
		BLOCK.TYPE.ENEMY:
			var node = _create_enemy(Vector3(x,y,z))
			state[x][y][z]=StateBlock.new(type, node)
		_: 
			assert(false, "not used the type")

func _create_cube(cubePosition: Vector3): 
	var cube = block_scene.instantiate() as Node3D
	cube.position = cubePosition
	
	cubes_node.add_child(cube)
	return cube

func _create_player(pos: Vector3): 
	var p = player_scene.instantiate() as Node3D
	p.position = pos
	characters_node.add_child(p)
	return p

func _create_enemy(pos: Vector3): 
	var e = enemy_scene.instantiate() as Node3D
	e.position = pos
	enemies_node.add_child(e)
	return e

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
