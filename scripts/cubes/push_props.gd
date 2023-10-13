class_name PushProp

var height = 1
var distance = 1
var direction: Vector2i = Vector2i(0,0)
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
	if block.y > from.y:
		direction.y = 1
	elif block.y < from.y:
		direction.y = -1
	return self

func isValid():
	if direction.x == 1 || direction.x == -1:
		return direction.y == 0
	if direction.y == 1 || direction.y == -1:
		return direction.x == 0
	return false
