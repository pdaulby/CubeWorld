class_name PushProp

var height = 1
var distance = 1
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
	if direction.y != 0: return false
	if direction.x == 1 || direction.x == -1:
		return direction.z == 0
	if direction.z == 1 || direction.z == -1:
		return direction.x == 0
	return false
