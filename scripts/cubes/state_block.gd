class_name StateBlock

var type: BLOCK.TYPE = BLOCK.TYPE.AIR
var node: Node3D = null
	
func _init(_type: BLOCK.TYPE, _node: Node3D):
	type = _type
	node = _node

static func Air():
	return StateBlock.new(BLOCK.TYPE.AIR, null)

func _to_string():
	return str(type)

