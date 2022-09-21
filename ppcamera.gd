extends Node2D

var pox=0
var poy=0
var temx=0
var temy=0
var if_drag=false

func _process(delta):
	#$cur.set_position(Vector2(pox,poy))
	$camera_point.set_position(Vector2(pox,poy))

func _unhandled_input(event):
	
	if event is InputEventMouseButton and event.is_pressed():
		temx=event.get_global_position().x+$Camera2D.get_global_position().x
		temy=event.get_global_position().y+$Camera2D.get_global_position().y
		if_drag=true
		
	elif event is InputEventMouseButton and !event.is_pressed():
#		temx=event.get_global_position().x
#		temy=event.get_global_position().y
		if_drag=false
		
	if if_drag==true:
		pox=-(event.get_global_position().x-temx)
		poy=-(event.get_global_position().y-temy)
	
	

