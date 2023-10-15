extends Node3D

var rotation_target = 0

var rotation_speed

func _input(event):
	if event.is_action_pressed("CamRight"):
		rotation_target += 1.5708
	if event.is_action_pressed("CamLeft"):
		rotation_target -= 1.5708

func _process(delta):
	
	rotation.y = move_toward(rotation.y, rotation_target, 3*delta)
