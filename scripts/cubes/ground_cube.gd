extends StaticBody3D
class_name GroundCube

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func highlight(highlighted: bool):
	#$WalkableHighlight.visible = true
	$TopHighlight.visible = highlighted
