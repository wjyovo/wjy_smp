extends Node2D

var if_drag=false
var tem_pos=Vector2.ZERO
onready var camera=$"../rts_camera/Camera2D"

#func _process(delta):
#	$CanvasLayer/cursor_kuang.rect_position=tem_pos

func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == BUTTON_LEFT:
			tem_pos=event.get_global_position()
			if_drag=true
	elif event is InputEventMouseButton and !event.is_pressed():
		if event.button_index == BUTTON_LEFT:
			$CanvasLayer/cursor_kuang.rect_position=Vector2(-1000,-1000)
			$CanvasLayer/cursor_kuang.rect_size=Vector2.ZERO
			if_drag=false
			
	if event is InputEventMouseButton:
		if event.get_global_position().x-tem_pos.x>=0 and event.get_global_position().y-tem_pos.y>=0:
			if if_drag==true:
				$CanvasLayer/cursor_kuang.rect_position=tem_pos
				$CanvasLayer/cursor_kuang.rect_size=event.get_global_position()-tem_pos
		elif event.get_global_position().x-tem_pos.x<0 and event.get_global_position().y-tem_pos.y<0:
			if if_drag==true:
				$CanvasLayer/cursor_kuang.rect_position=event.get_global_position()
				$CanvasLayer/cursor_kuang.rect_size=tem_pos-event.get_global_position()
		elif event.get_global_position().x-tem_pos.x<0 and event.get_global_position().y-tem_pos.y>=0:
			if if_drag==true:
				$CanvasLayer/cursor_kuang.rect_position=Vector2(event.get_global_position().x,tem_pos.y)
				$CanvasLayer/cursor_kuang.rect_size=Vector2(tem_pos.x-event.get_global_position().x,
				event.get_global_position().y-tem_pos.y)
		elif event.get_global_position().x-tem_pos.x>=0 and event.get_global_position().y-tem_pos.y<0:
			if if_drag==true:
				$CanvasLayer/cursor_kuang.rect_position=Vector2(tem_pos.x,event.get_global_position().y)
				$CanvasLayer/cursor_kuang.rect_size=Vector2(event.get_global_position().x-tem_pos.x,
				tem_pos.y-event.get_global_position().y)
	
	
