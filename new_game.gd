extends Node2D

onready var quanju=$"/root/Quanju" 

func _on_start_pressed():
	quanju.map_seed=int($CanvasLayer/LineEdit.text)
	get_tree().change_scene("res://scn/main.tscn")
	

