class_name Player extends Node3D

var active: bool = true
var abilities = []

func _ready():
	abilities = [$PlayerMovement, $BlockPusher]

func activate_ability(i: int):
	for ability in abilities:
		ability.active = false
	abilities[i].active = true

func kill():
	assert(false, "implement player kill")
