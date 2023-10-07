class_name BlockHighlighter extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func highlight_top(location: Vector3):
	$TopHighlight.visible = true
	position = location

func unhighlight():
	$TopHighlight.visible = false
