extends Node3D

var block_scene: PackedScene = preload("res://scenes/ground_cube.tscn")
var player_scene: PackedScene = preload("res://scenes/player.tscn")
var cubes_node: Node

var state: Array = []

func _ready():
	cubes_node = get_node("Environment/Cubes")
	call_deferred("_init_world")

func _init_world():
	_construct_world(WorldSave.new())
	print(state)

func _construct_world(save: WorldSave):
	_create_empty_state(save)
	print(state)
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
	cubes_node.add_child(cube)
	return cube

func _create_empty_state(save: WorldSave):
	state.resize(save.x)
	for x in save.x:
		state[x] = []
		state[x].resize(save.y)
		for y in save.y:
			state[x][y] = []
			state[x][y].resize(save.z)
			for z in save.z:
				state[x][y][z] = StateBlock.new(BLOCK.TYPE.AIR, null)
