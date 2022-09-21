extends Node2D

export(bool) var if_map_finish=false
export(bool) var can_lz=false
export(bool) var start_play=false
export(bool) var load_demo_map=false

var save_path="D:/"
onready var world_tree
onready var world_rock
onready var world_building
onready var if_build
onready var tilemap


func _ready():
	$CanvasLayer/page/luzhi_kaiguan.pressed=false
	$CanvasLayer/page.visible=false
	$CanvasLayer/Button.visible=false
	

func _process(delta):
	if if_map_finish==true:
		$CanvasLayer/Button.visible=true
		world_tree=$"/root/main/map/YSort/treetile"
		world_rock=$"/root/main/map/YSort/rock"
		world_building=$"/root/main/map/YSort/building"
		if_build=$"/root/main/map/Navigation2D/if_build"
		tilemap=$"/root/main/map/TileMap"
		
	
	
	if $CanvasLayer/page/luzhi_kaiguan.pressed==true:
		can_lz=true
	elif $CanvasLayer/page/luzhi_kaiguan.pressed==false:
		can_lz=false
	
	$CanvasLayer/page/v2.text=str($CanvasLayer/page/HSlider.value)
	
	

func _on_Button_pressed():
	if $CanvasLayer/page.visible==false:
		$CanvasLayer/page.visible=true
	elif $CanvasLayer/page.visible==true:
		$CanvasLayer/page.visible=false


func _on_HSlider_value_changed(value):
	Engine.time_scale=$CanvasLayer/page/HSlider.value


func _on_play_pressed():
	load_demo_map=true
	start_play=true
	
	
func _on_save_map_pressed():
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
	var error=file.open(save_path+"demo_map.dat",File.WRITE)
	
	if error==OK:
		file.store_var(data)
		file.close()
