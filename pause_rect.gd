extends ColorRect

const SQLite=preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var attr="res://dbstore/role_attr"
var save_path="D:/"
onready var world_tree=$"/root/main/map/YSort/treetile"
onready var world_rock=$"/root/main/map/YSort/rock"
onready var world_building=$"/root/main/map/YSort/building"


func _ready():
	db=SQLite.new()
	db.path=attr
	$cd.visible=false

func _on_cundang_pressed():
	$cd.visible=true


func _on_cd_pressed():
	db.open_db()
	var tableName="cundang"
	var dict:Dictionary=Dictionary()
	dict["player_name"]=$"/root/Quanju".player_name
	dict["cundang_name"]=$cd/LineEdit.text+".dat"
	dict["path"]=save_path+$cd/LineEdit.text+".dat"
	db.insert_row(tableName,dict)
	
	var world_tree_array=[]
	for i in range(1,100):
		for j in range(1,100):
			var world_num=world_tree.get_cell(i,j)
			world_tree_array.push_back(world_num)
	
	var world_rock_array=[]
	for i in range(1,100):
		for j in range(1,100):
			var world_num=world_rock.get_cell(i,j)
			world_rock_array.push_back(world_num)
	
	var world_building_array=[]
	for i in range(1,100):
		for j in range(1,100):
			var world_num=world_building.get_cell(i,j)
			world_building_array.push_back(world_num)
	
	var data={
		"world_tree":world_tree_array,
		"world_rock":world_rock_array,
		"world_building":world_building_array,
	}

	var file=File.new()
	var error=file.open(save_path+$cd/LineEdit.text+".dat",File.WRITE)
	if error==OK:
		file.store_var(data)
		file.close()
	
	$"/root/Quanju".start_cd=true
	
	$cd.visible=false
