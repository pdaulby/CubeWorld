class_name CharacterUI extends Node

var player: Player
#TODO set player and make buttons dynamically

func _ready():
	call_deferred("_get_player")


func activate_ability(i: int): 
	get_player().activate_ability(i)

func get_player():
	if player == null:
		var c = get_node("/root/World/Environment/Characters").get_children()
		if !c.is_empty(): 
			player = c[0] as Player
	return player
