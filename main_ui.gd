extends Node2D

const SQLite=preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var attr="res://dbstore/role_attr"
var save_path="D:/"
onready var quanju=$"/root/Quanju"



func _ready():
	db=SQLite.new()
	db.path=attr
	$CanvasLayer/load_page.visible=false

func _on_quit_pressed():
	get_tree().quit()

func _on_new_pressed():
	get_tree().change_scene("res://scn/new_game.tscn")

func _on_load_pressed():
	db.open_db()
	db.query("select * from cundang;")
	
	$CanvasLayer/load_page.visible=true
	
	for i in range(0,db.query_result.size()):
		if db.query_result[i]["player_name"]==quanju.player_name:
			var bt=get_node("CanvasLayer/load_page/load"+str(i+1))
			bt.visible=true
			bt.text=db.query_result[i]["cundang_name"]
