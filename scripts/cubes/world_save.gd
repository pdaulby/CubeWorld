extends Resource
class_name WorldSave

@export var bounds: Vector3i = Vector3i(4,3,6)

@export var world = [
	[
		[1,1,0,1,1,1],
		[0,0,0,0,0,0],
		[0,0,0,0,0,0],
	],
	[
		[1,1,1,1,1,1],
		[0,0,0,0,0,0],
		[0,0,0,0,0,0],
	],
	[
		[1,1,1,1,1,1],
		[0,1,0,3,1,0],
		[0,0,0,0,0,0],
	],
	[
		[1,1,1,1,1,0],
		[1,1,1,0,0,0],
		[0,2,0,0,0,0],
	],
]
