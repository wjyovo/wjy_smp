extends Node2D

onready var choose=$Area2D/CollisionShape2D
onready var choose_x=$Area2D/CollisionShape2D.shape.extents.x
onready var choose_y=$Area2D/CollisionShape2D.shape.extents.y

onready var camera=$"../rts_camera/Camera2D"

var if_drag=false
var tem_pos=Vector2.ZERO
var now_pos=Vector2.ZERO

func _process(delta):
	choose.shape.extents=(now_pos-tem_pos)/2*camera.zoom.x
	
	choose.set_position(camera.get_global_position()+
			(now_pos-Vector2(960,540))*camera.zoom.x-choose.shape.extents)
	

func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == BUTTON_LEFT:
			choose.set_position(camera.get_global_position()+
			(event.get_global_position()-Vector2(960,540))*camera.zoom.x+
			Vector2(choose.shape.extents.x,choose.shape.extents.y))
			if_drag=true
			tem_pos=event.get_global_position()
			
	elif event is InputEventMouseButton and !event.is_pressed():
		if event.button_index == BUTTON_LEFT:
			choose.set_position(Vector2(-1000,-1000))
			tem_pos=Vector2.ZERO
			now_pos=Vector2.ZERO
			if_drag=false
	
	if if_drag==true:
		now_pos=event.get_global_position()
		

