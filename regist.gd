extends Node2D

const SQLite=preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var attr="res://dbstore/role_attr"

func _ready():
	$CanvasLayer/landing_page.visible=true
	$CanvasLayer/register_page.visible=false
	
	db=SQLite.new()
	db.path=attr

func _on_to_register_pressed():
	$CanvasLayer/landing_page.visible=false
	$CanvasLayer/register_page.visible=true

func landing():
	db.open_db()
	db.query("select * from player_date;")
	
	var if_land=false
	
	for i in range(0,db.query_result.size()):
		if db.query_result[i]["name"]==$CanvasLayer/landing_page/nick_name.text and \
		db.query_result[i]["password"]==int($CanvasLayer/landing_page/password.text):
			print("land success")
			if_land=true
			$"/root/Quanju".player_name=db.query_result[i]["name"]
			get_tree().change_scene("res://scn/main_ui.tscn")
		else:
			print("landing...")
		
		if i==db.query_result.size()-1 and if_land==false:
			print("land error")
	
func register():
	db.open_db()
	var tableName="player_date"
	var dict:Dictionary=Dictionary()
	dict["name"]=$CanvasLayer/register_page/nick_name.text
	dict["password"]=int($CanvasLayer/register_page/password.text)
	
	if $CanvasLayer/register_page/password.text==$CanvasLayer/register_page/confirm.text:
		db.insert_row(tableName,dict)
	else:
		print("can not match")
	
	$CanvasLayer/landing_page.visible=true
	$CanvasLayer/register_page.visible=false
	
func _on_landing_pressed():
	landing()

func _on_register_pressed():
	register()
