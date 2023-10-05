extends Resource

class_name World_Save
enum TYPE { AIR, BLOCK }

@export var x: int = 4
@export var y: int = 3
@export var z: int = 6

@export var world = [
	[
		[1,1,1,1,1,0],
		[0,0,0,0,0,0],
		[0,0,0,0,0,0],
	],
	[
		[1,1,1,1,1,1],
		[0,1,0,0,1,0],
		[0,0,0,0,0,0],
	],
	[
		[1,1,1,1,1,1],
		[0,0,0,0,0,0],
		[0,0,0,0,0,0],
	],
	[
		[1,1,0,1,1,1],
		[0,0,0,0,0,0],
		[0,0,0,0,0,0],
	],
]
