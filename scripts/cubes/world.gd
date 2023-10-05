extends Node3D

var scene: PackedScene = preload("res://scenes/ground_cube.tscn")

func _ready():
	call_deferred("_init_world")

func _init_world():
	_construct_world(World_Save.new())

func _construct_world(save: World_Save):
	var x = 0
	for xyz in save.world:
		var y = 0
		for yz in xyz:
			var z = 0
			for zType in yz:
				_create_item(zType, Vector3(x,y,z))
				z = z + 1
			y = y + 1
		x = x + 1
	pass

func _create_item(type: int, itemPosition: Vector3):
	match type:
		0: #AIR
			return
		1: #BLOCK
			_create_cube(itemPosition)

func _create_cube(cubePosition: Vector3): 
	var cube = scene.instantiate()  as Node3D
	cube.position = cubePosition
	
	get_tree().root.add_child(cube)
	
