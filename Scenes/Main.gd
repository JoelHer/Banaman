extends Node2D

func _process(delta):
	$Camera2D.global_position.x = $Player.position.x
	$Camera2D.global_position.y = $Player.position.y -100
