class_name HeightBlock

var height: int
var xz: Vector2i
var block: StateBlock
var G: int = 0
var H: int = 0
var previous: HeightBlock = null
var blocked = false
	
func _init(_height: int, _xz: Vector2i, _block: StateBlock):
	height = _height
	xz = _xz
	block = _block

func _to_string():
	return str(block.type)

func is_blocked():
	return blocked
