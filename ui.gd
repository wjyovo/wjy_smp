extends Node2D

onready var building=$"../map/YSort/building"
onready var if_build=$"../map/Navigation2D/if_build"
onready var camera=$"../rts_camera/Camera2D"
onready var map=$"../map/YSort/unit"
onready var building_choose=$"../building_choose"
onready var human_worker=preload("res://scn/chracter/human/human_worker.tscn")

var if_base=false
var if_factory=false
var if_factory2=false


func _ready():
	$game_ui/main/unit.visible=false
	$game_ui/pause_rect.visible=false
	init_ui()

func _process(delta):
	if if_base==true:
		pass
	elif if_factory==true:
		pass
	elif if_factory2==true:
		pass

func init_ui():
	$game_ui/unit.visible=false
	$game_ui/main.visible=true
	$game_ui/build.visible=false
	if_base=false
	if_factory=false
	if_factory2=false

func _on_build_pressed():
	$game_ui/build.visible=true
	$game_ui/main.visible=false


func _on_base_pressed():
	if_base=true
	if_factory=false
	if_factory2=false

func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if if_base==true:
			if event.button_index == BUTTON_LEFT:
				var map_position = building.world_to_map(camera.get_global_position()+
				(event.get_global_position()-Vector2(960,540))*camera.zoom.x)
				if if_build.get_cellv(map_position)==0 and \
				if_build.get_cellv(map_position+Vector2(-1,0))==0 and \
				if_build.get_cellv(map_position+Vector2(-1,-1))==0 and \
				if_build.get_cellv(map_position+Vector2(0,-1))==0:
					building.set_cellv(map_position,0)
					if_build.set_cellv(map_position,1)
					if_build.set_cellv(map_position+Vector2(-1,0),1)
					if_build.set_cellv(map_position+Vector2(-1,-1),1)
					if_build.set_cellv(map_position+Vector2(0,-1),1)
					
			elif event.button_index == BUTTON_RIGHT:
				init_ui()
		elif if_factory==true:
			if event.button_index == BUTTON_LEFT:
				var map_position = building.world_to_map(camera.get_global_position()+
				(event.get_global_position()-Vector2(960,540))*camera.zoom.x)
				if if_build.get_cellv(map_position)==0:
					building.set_cellv(map_position,1)
					if_build.set_cellv(map_position,1)
			elif event.button_index == BUTTON_RIGHT:
				init_ui()
		elif if_factory2==true:
			if event.button_index == BUTTON_LEFT:
				var map_position = building.world_to_map(camera.get_global_position()+
				(event.get_global_position()-Vector2(960,540))*camera.zoom.x)
				if if_build.get_cellv(map_position)==0:
					building.set_cellv(map_position,2)
					if_build.set_cellv(map_position,1)
			elif event.button_index == BUTTON_RIGHT:
				init_ui()
			


func _on_factory_pressed():
	if_factory=true
	if_base=false
	if_factory2=false


func _on_cancel_pressed():
	init_ui()


func _on_factory2_pressed():
	if_factory2=true
	if_base=false
	if_factory=false


func _on_unit_pressed():
	$game_ui/unit.visible=true
	$game_ui/main.visible=false


func _on_worker_pressed():
	var worker=human_worker.instance()
	map.add_child(worker)
	worker.set_position(building_choose.tem_pos)
	

func _on_pause_pressed():
	$game_ui/pause_rect.visible=true
	get_tree().paused=true


func _on_continue_pressed():
	$game_ui/pause_rect.visible=false
	get_tree().paused=false

