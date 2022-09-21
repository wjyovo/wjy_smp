extends Button

const SQLite=preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var attr="res://dbstore/role_attr"
onready var quanju=$"/root/Quanju"

func _ready():
	db=SQLite.new()
	db.path=attr

func _on_load1_pressed():
	db.open_db()
	db.query("select * from cundang;")
	
	for i in range(0,db.query_result.size()):
		if db.query_result[i]["player_name"]==quanju.player_name and \
		db.query_result[i]["cundang_name"]==self.text:
			quanju.path=db.query_result[i]["path"]
			quanju.cundang_name=db.query_result[i]["cundang_name"]
	
	get_tree().change_scene("res://scn/main.tscn")
