extends Node2D

onready var building=$"../map/YSort/building"
onready var camera=$"../rts_camera/Camera2D"
onready var unit_make=$"../ui/game_ui/main/unit"
export(Vector2) var tem_pos=Vector2.ZERO

func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index==BUTTON_LEFT:
			var map_position = building.world_to_map(camera.get_global_position()+
			(event.get_global_position()-Vector2(960,540))*camera.zoom.x)
			
			if building.get_cellv(map_position)==1:
				
				$CanvasLayer/Label.text=str(tem_pos)
				
			elif building.get_cellv(map_position)==2:
				
				$CanvasLayer/Label.text=str(tem_pos)
				
			elif building.get_cellv(map_position)==0 or \
			building.get_cellv(map_position+Vector2(1,0))==0 or \
			building.get_cellv(map_position+Vector2(0,1))==0 or \
			building.get_cellv(map_position+Vector2(1,1))==0:
				unit_make.visible=true
				tem_pos=building.map_to_world(map_position)+Vector2(0,500)
				$CanvasLayer/Label.text=str(tem_pos)
				
			else:
				unit_make.visible=false
				$CanvasLayer/Label.text=str(tem_pos)
