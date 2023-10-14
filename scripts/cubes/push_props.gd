class_name PushProp

var height = 2
var distance = 3
var direction: Vector3i = Vector3i(0,0,0)
var block: Vector3i
	
func _init(_block: Vector3i):
	block = _block

func from(from: Vector3i) -> PushProp:
	if from.y != block.y: 
		return self
	if block.x > from.x:
		direction.x = 1
	elif block.x < from.x:
		direction.x = -1
	if block.z > from.z:
		direction.z = 1
	elif block.z < from.z:
		direction.z = -1
	return self

func is_valid():
	if distance <= 0: return false
	if direction.y != 0: 
		return direction.y == -1 && direction.x == 0 && direction.z == 0
	if direction.x == 1 || direction.x == -1:
		return direction.z == 0
	if direction.z == 1 || direction.z == -1:
		return direction.x == 0
	return false
