extends Node2D

func _ready():
	$Camera2D.zoom.x=10
	$Camera2D.zoom.y=10

func _unhandled_input(event):
	$camera_point/cur.set_position(Vector2(event.get_global_position().x-960,event.get_global_position().y-540))
	
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == BUTTON_WHEEL_UP and $Camera2D.zoom.x>=1:
			$Camera2D.zoom.x=$Camera2D.zoom.x-0.1
			$Camera2D.zoom.y=$Camera2D.zoom.y-0.1
		elif event.button_index == BUTTON_WHEEL_DOWN and $Camera2D.zoom.x<=20:
			$Camera2D.zoom.x=$Camera2D.zoom.x+0.1
			$Camera2D.zoom.y=$Camera2D.zoom.y+0.1
	
	
	
