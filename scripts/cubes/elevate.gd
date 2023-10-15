class_name Elevate extends Node

var world: World
var player: Player

func _ready():
	player = get_parent() as Player
	world = get_node("/root/World")

func activate():
	if world.processing || !player.active: return
	
