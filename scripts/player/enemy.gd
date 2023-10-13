class_name Enemy extends Node3D

func kill():
	var blood: GPUParticles3D = $Blood
	blood.emitting = true
	$Sprite3D.visible = false
	await get_tree().create_timer(1.0).timeout
	queue_free()
