extends Node2D

func _on_TextureButton_pressed():
	get_tree().change_scene("res://scenes/splash.tscn")


func _on_DirectorNode_game_ended(game_ender, task_count):
	visible = true
	$Description.text = "Your game was ended by %s. You had %d tasks left undone." % [game_ender, task_count]
