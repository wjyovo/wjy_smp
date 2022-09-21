extends KinematicBody2D

export(int) var state=0
export(int) var role_num=1

onready var camera=$"/root/main/rts_camera/Camera2D"
onready var ui_role_name=$"/root/main/ui/game_ui/info/role_n"
onready var ui_role_hp=$"/root/main/ui/game_ui/info/role_hp"
onready var ui_role_atk=$"/root/main/ui/game_ui/info/role_atk"
onready var ui_role_miaoshu=$"/root/main/ui/game_ui/info/role_miaoshu"
const SQLite=preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var attr="res://dbstore/role_attr"

export(bool) var be_choosen=false
var mouse_press=false
var npath=PoolVector2Array()
var velocity=Vector2.ZERO
var speed=100
var tem_pos=Vector2.ZERO

var role_name
var hp
var atk
var miaoshu

var if_cd=false

export(int) var unit_num
var frame=0

func _process(delta):
	if state==0:
		$AnimatedSprite.animation="idle"
	elif state==1:
		$AnimatedSprite.animation="work"
	elif state==2:
		$AnimatedSprite.animation="walk"
	elif state==3:
		$AnimatedSprite.animation="die"
	
	if be_choosen==true:
		ui_role_name.text=role_name
		ui_role_hp.text=str(hp)
		ui_role_atk.text=str(atk)
		ui_role_miaoshu.text=miaoshu
		$hp_ui.visible=true
	elif be_choosen==false:
		ui_role_name.text=" "
		ui_role_hp.text=" "
		ui_role_atk.text=" "
		ui_role_miaoshu.text=" "
		$hp_ui.visible=false
	
	if $"/root/Quanju".start_cd==true and if_cd==false:
		update_unit_sql()
		if_cd=true
	
	if $"/root/Luzhi".can_lz==true:
		update_demo()
		frame=frame+1
	
	if $"/root/Luzhi".start_play==true:
		demo_unit_update()
		frame=frame+1

func demo_unit_update():
	db.open_db()
	db.query("SELECT * FROM playdemo WHERE unit_num="+str(unit_num))
	
	for i in range(0,db.query_result.size()):
		if db.query_result[i]["frame"]==frame:
			self.position.x=db.query_result[i]["pos_x"]
			self.position.y=db.query_result[i]["pos_y"]


func update_unit_sql():
	db.open_db()
	var tableName="unit_attr"
	var dict:Dictionary=Dictionary()
	dict["player_name"]=$"/root/Quanju".player_name
	dict["cundang_name"]=$"/root/main/ui/game_ui/pause_rect/cd/LineEdit".text+".dat"
	dict["name"]=role_name
	dict["position_x"]=self.position.x
	dict["position_y"]=self.position.y
	db.insert_row(tableName,dict)

func _ready():
	randomize()
	unit_num=int(rand_range(0,114514))
	db=SQLite.new()
	db.path=attr
	show_hp()
	set_physics_process(false)

func _physics_process(delta):
	var move_distance=speed*delta
	move_along_path(move_distance)

func _on_Area2D_area_entered(area):
	if mouse_press==true:
		be_choosen=true


func _on_Area2D_area_exited(area):
	if mouse_press==true:
		be_choosen=false


func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == BUTTON_LEFT:
			be_choosen=false
			mouse_press=true
		elif event.button_index == BUTTON_RIGHT and be_choosen==true:
			tem_pos=camera.get_global_position()+(event.get_global_position()-Vector2(960,540))*camera.zoom.x
			npath=$"/root/main/map/Navigation2D".get_simple_path(self.get_global_position(),tem_pos)
			set_physics_process(true)
	elif event is InputEventMouseButton and !event.is_pressed():
		if event.button_index == BUTTON_LEFT:
			mouse_press=false
	
func move_along_path(distance):
	var start_point=position
	if npath[0].x-start_point.x>=0:
		$AnimatedSprite.flip_h=true
	elif npath[0].x-start_point.x<0:
		$AnimatedSprite.flip_h=false
	for i in range(npath.size()):
		var distance_to_next=start_point.distance_to(npath[0])
		if distance<=distance_to_next and distance>=0:
			position=start_point.linear_interpolate(npath[0],distance/distance_to_next)
			move_and_slide(velocity)
			state=2
			break
		distance-=distance_to_next
		start_point=npath[0]
		npath.remove(0)
	
	
	if npath.size()==0:
		set_physics_process(false)
		state=0

func show_hp():
	
	db.open_db()
	db.query("select * from attribution;")
	var id=role_num-1
	
	role_name=db.query_result[id]["name"]
	hp=db.query_result[id]["hp"]
	atk=db.query_result[id]["atk"]
	miaoshu=db.query_result[id]["miaoshu"]
	
func update_demo():
	db.open_db()
	
	var tableName="playdemo"
	var dict:Dictionary=Dictionary()
	dict["player_name"]=$"/root/Quanju".player_name
	dict["demo_name"]="demo_map.dat"
	dict["map_path"]="D:/demo_map.dat"
	dict["frame"]=frame
	dict["unit_num"]=unit_num
	dict["pos_x"]=self.position.x
	dict["pos_y"]=self.position.y
	db.insert_row(tableName,dict)
	
	
	
	
	
	
	
	
	
	
	
