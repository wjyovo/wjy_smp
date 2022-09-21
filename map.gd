extends Node2D

onready var noisemap=$map_noise
onready var player=preload("res://scn/born_player.tscn")
onready var born3=preload("res://scn/chracter/human/human_worker.tscn")
onready var _unit=preload("res://scn/unit.tscn")
onready var quanju=$"/root/Quanju"
onready var luzhi=$"/root/Luzhi"
var num=0

const SQLite=preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var attr="res://dbstore/role_attr"
var unit_init=false

onready var b_player1=player.instance()
onready var b_player2=player.instance()
onready var b_player3=player.instance()
onready var b_player4=player.instance()

func map_build():
	noisemap.texture.noise.seed=quanju.map_seed
	
	$TileMap.clear()
	$YSort/treetile.clear()
	$YSort/building.clear()
	$YSort/rock.clear()
	$Navigation2D/if_build.clear()
	num=0
	rock_build()
	rock_add()
	tree_build()
	player_born1()

func map_load():
	$TileMap.clear()
	$YSort/treetile.clear()
	$YSort/building.clear()
	$YSort/rock.clear()
	$Navigation2D/if_build.clear()
	
	for i in range(1,100):
		for j in range(1,100):
			$TileMap.set_cell(i,j,3)
	
	
	var file=File.new()
	if file.file_exists(quanju.path):
		var error=file.open(quanju.path,File.READ)
		if error==OK:
			var player_data=file.get_var()
			var tree_array=player_data["world_tree"]
			var rock_array=player_data["world_rock"]
			var building_array=player_data["world_building"]
			
			
			
			var array_num=0
			var numz=0
			for i in range(1,100):
				for j in range(1,100):
					numz=tree_array[array_num]
					if numz>=0:
						$YSort/treetile.set_cell(i,j,numz)
					array_num=array_num+1
			
			array_num=0
			for i in range(1,100):
				for j in range(1,100):
					numz=rock_array[array_num]
					if numz>=0:
						$YSort/rock.set_cell(i,j,numz)
					array_num=array_num+1
			
			array_num=0
			for i in range(1,100):
				for j in range(1,100):
					numz=building_array[array_num]
					if numz>=0:
						$YSort/building.set_cell(i,j,numz)
					array_num=array_num+1
			
			file.close()
	update_if_build()
	load_unit()
	
func load_unit():
	db.open_db()
	db.query("SELECT * FROM unit_attr WHERE player_name='"+quanju.player_name+
	"' and cundang_name='"+quanju.cundang_name+"'")
	
	for i in range(0,db.query_result.size()):
		var loaded_unit=born3.instance()
		$YSort/unit.add_child(loaded_unit)
		loaded_unit.set_position(Vector2(db.query_result[i]["position_x"],
		db.query_result[i]["position_y"]))
	
func _ready():
	db=SQLite.new()
	db.path=attr
	
	if quanju.path=="no":
		map_build()
	else:
		map_load()
	luzhi.if_map_finish=true
	
func rock_wei3(i,j):
	$Navigation2D/if_build.set_cell(i,j,1)
	$Navigation2D/if_build.set_cell(i-1,j,1)
	$Navigation2D/if_build.set_cell(i-2,j,1)
	$Navigation2D/if_build.set_cell(i,j-1,1)
	$Navigation2D/if_build.set_cell(i-1,j-1,1)
	$Navigation2D/if_build.set_cell(i-2,j-1,1)
	$Navigation2D/if_build.set_cell(i,j-2,1)
	$Navigation2D/if_build.set_cell(i-1,j-2,1)
	$Navigation2D/if_build.set_cell(i-2,j-2,1)

func rock_wei2(i,j):
	$Navigation2D/if_build.set_cell(i,j,1)
	$Navigation2D/if_build.set_cell(i-1,j,1)
	$Navigation2D/if_build.set_cell(i,j-1,1)
	$Navigation2D/if_build.set_cell(i-1,j-1,1)

func rock_get3(i,j):
	if $Navigation2D/if_build.get_cell(i,j)==0 and \
	$Navigation2D/if_build.get_cell(i-1,j)==0 and \
	$Navigation2D/if_build.get_cell(i-2,j)==0 and \
	$Navigation2D/if_build.get_cell(i,j-1)==0 and \
	$Navigation2D/if_build.get_cell(i-1,j-1)==0 and \
	$Navigation2D/if_build.get_cell(i-2,j-1)==0 and \
	$Navigation2D/if_build.get_cell(i,j-2)==0 and \
	$Navigation2D/if_build.get_cell(i-1,j-2)==0 and \
	$Navigation2D/if_build.get_cell(i-2,j-2)==0:
		return true
	else:
		return false

func rock_get2(i,j):
	if $Navigation2D/if_build.get_cell(i,j)==0 and \
	$Navigation2D/if_build.get_cell(i-1,j)==0 and \
	$Navigation2D/if_build.get_cell(i,j-1)==0 and \
	$Navigation2D/if_build.get_cell(i-1,j-1)==0:
		return true
	else:
		return false

func tree_build():
	for i in range(1,100):
		for j in range(1,100):
			var p=noisemap.texture.noise.get_noise_2d(i,j)
			if p<=0 and $Navigation2D/if_build.get_cell(i,j)==0:
				randomize()
				var tree=rand_range(0,3)
				if tree<=1:
					$YSort/treetile.set_cell(i,j,0)
				elif tree<=2:
					$YSort/treetile.set_cell(i,j,1)
				elif tree<=3:
					$YSort/treetile.set_cell(i,j,2)
				$Navigation2D/if_build.set_cell(i,j,1)
			elif p>0:
				pass
	
func rock_build():
	for i in range(1,100):
		for j in range(1,100):
			$TileMap.set_cell(i,j,3)
			$Navigation2D/if_build.set_cell(i,j,0)
			randomize()
			var rock=rand_range(0,2000)
			if rock<=1 and rock_get3(i,j)==true:
				$YSort/rock.set_cell(i,j,2)
				rock_wei3(i,j)
			elif rock>=1999 and rock_get2(i,j)==true:
				var rock_r=rand_range(0,2)
				if rock_r<=1:
					$YSort/rock.set_cell(i,j,0)
				else:
					$YSort/rock.set_cell(i,j,1)
				rock_wei2(i,j)
			elif rock>=114 and rock<=115 and $Navigation2D/if_build.get_cell(i,j)==0:
				var rock_r=rand_range(0,3)
				if rock_r<=1:
					$YSort/rock.set_cell(i,j,4)
				elif rock_r<=2:
					$YSort/rock.set_cell(i,j,5)
				elif rock_r<=3:
					$YSort/rock.set_cell(i,j,6)
				$Navigation2D/if_build.set_cell(i,j,1)
				
func rock_add():
	for i in range(1,100):
		for j in range(1,100):
			if $YSort/rock.get_cell(i,j)==2:
				var x=i+2
				var y=j+2
				for a in range(0,6):
					for b in range(0,6):
						randomize()
						var if_rock=rand_range(0,5)
						if if_rock<1:
							if rock_get2(x-a,y-b)==true:
								randomize()
								var add_rock=rand_range(0,2)
								if add_rock<=1:
									$YSort/rock.set_cell(x-a,y-b,0)
								elif add_rock>1:
									$YSort/rock.set_cell(x-a,y-b,1)
								rock_wei2(x-a,y-b)
	
	for i in range(1,100):
		for j in range(1,100):
			if $YSort/rock.get_cell(i,j)==0 or $YSort/rock.get_cell(i,j)==1:
				var x=i+2
				var y=j+2
				for a in range(0,6):
					for b in range(0,6):
						randomize()
						var if_rock=rand_range(0,2)
						if if_rock<1:
							if $Navigation2D/if_build.get_cell(x-a,y-b)==0:
								randomize()
								var add_rock=rand_range(0,3)
								if add_rock<=1:
									$YSort/rock.set_cell(x-a,y-b,4)
								elif add_rock<=2:
									$YSort/rock.set_cell(x-a,y-b,5)
								elif add_rock<=3:
									$YSort/rock.set_cell(x-a,y-b,6)
								$Navigation2D/if_build.set_cell(x-a,y-b,1)
						
func player_born1():
	var a=1
	for i in range(1,40):
		for j in range(1,50):
			if get88(i,j)==true:
				var local_position = $TileMap.map_to_world(Vector2(i,j))
				var global_position = $TileMap.to_global(local_position)
				
				randomize()
				var rand_born=rand_range(0,200)
				if rand_born<=1:
					
					self.add_child(b_player1)
					#wei88(i,j)
					b_player1.set_position(global_position+Vector2(0,-384))
					
					var b1=born3.instance()
					$YSort/unit.add_child(b1)
					b1.set_position(b_player1.get_global_position())
					
					var b2=born3.instance()
					$YSort/unit.add_child(b2)
					b2.set_position(b_player1.get_global_position()+Vector2(100,200))
					
					var b3=born3.instance()
					$YSort/unit.add_child(b3)
					b3.set_position(b_player1.get_global_position()+Vector2(-100,-200))
					
					num=num+1
					
					if num==1:
						a=0
						player_born2()
						break
			if i==39 and j==49 and num<1:
				player_born1()
		if a==0:
			break
	
func player_born2():
	var b=1
	for i in range(50,100):
		for j in range(1,40):
			if get88(i,j)==true:
				var local_position = $TileMap.map_to_world(Vector2(i,j))
				var global_position = $TileMap.to_global(local_position)
				
				randomize()
				var rand_born=rand_range(0,200)
				if rand_born<=1:
					
					self.add_child(b_player2)
					wei88(i,j)
					b_player2.set_position(global_position+Vector2(0,-384))
					num=num+1
					
					if num==2:
						b=0
						player_born3()
						break
			if i==99 and j==39 and num<2:
				player_born2()
		if b==0:
			break
	
func player_born3():
	var c=1
	for i in range(1,50):
		for j in range(60,100):
			if get88(i,j)==true:
				var local_position = $TileMap.map_to_world(Vector2(i,j))
				var global_position = $TileMap.to_global(local_position)
				
				randomize()
				var rand_born=rand_range(0,200)
				if rand_born<=1:
					
					self.add_child(b_player3)
					wei88(i,j)
					b_player3.set_position(global_position+Vector2(0,-384))
					num=num+1
					
					if num==3:
						c=0
						player_born4()
						break
			if i==49 and j==99 and num<3:
				player_born3()
		if c==0:
			break
	
func player_born4():
	var d=1
	for i in range(60,100):
		for j in range(50,100):
			if get88(i,j)==true:
				var local_position = $TileMap.map_to_world(Vector2(i,j))
				var global_position = $TileMap.to_global(local_position)
				
				randomize()
				var rand_born=rand_range(0,200)
				if rand_born<=1:
					
					self.add_child(b_player4)
					wei88(i,j)
					b_player4.set_position(global_position+Vector2(0,-384))
					num=num+1
					
					if num==4:
						d=0
						
						
						
						
						break
			if i==99 and j==99 and num<4:
				player_born4()
		if d==0:
			break
	
func get88(i,j):
	if $Navigation2D/if_build.get_cell(i,j)==0 and \
	$Navigation2D/if_build.get_cell(i-1,j)==0 and \
	$Navigation2D/if_build.get_cell(i-2,j)==0 and \
	$Navigation2D/if_build.get_cell(i-3,j)==0 and \
	$Navigation2D/if_build.get_cell(i-4,j)==0 and \
	$Navigation2D/if_build.get_cell(i-5,j)==0 and \
	$Navigation2D/if_build.get_cell(i-6,j)==0 and \
	$Navigation2D/if_build.get_cell(i-7,j)==0 and \
	$Navigation2D/if_build.get_cell(i,j-1)==0 and \
	$Navigation2D/if_build.get_cell(i-1,j-1)==0 and \
	$Navigation2D/if_build.get_cell(i-2,j-1)==0 and \
	$Navigation2D/if_build.get_cell(i-3,j-1)==0 and \
	$Navigation2D/if_build.get_cell(i-4,j-1)==0 and \
	$Navigation2D/if_build.get_cell(i-5,j-1)==0 and \
	$Navigation2D/if_build.get_cell(i-6,j-1)==0 and \
	$Navigation2D/if_build.get_cell(i-7,j-1)==0 and \
	$Navigation2D/if_build.get_cell(i,j-2)==0 and \
	$Navigation2D/if_build.get_cell(i-1,j-2)==0 and \
	$Navigation2D/if_build.get_cell(i-2,j-2)==0 and \
	$Navigation2D/if_build.get_cell(i-3,j-2)==0 and \
	$Navigation2D/if_build.get_cell(i-4,j-2)==0 and \
	$Navigation2D/if_build.get_cell(i-5,j-2)==0 and \
	$Navigation2D/if_build.get_cell(i-6,j-2)==0 and \
	$Navigation2D/if_build.get_cell(i-7,j-2)==0 and \
	$Navigation2D/if_build.get_cell(i,j-3)==0 and \
	$Navigation2D/if_build.get_cell(i-1,j-3)==0 and \
	$Navigation2D/if_build.get_cell(i-2,j-3)==0 and \
	$Navigation2D/if_build.get_cell(i-3,j-3)==0 and \
	$Navigation2D/if_build.get_cell(i-4,j-3)==0 and \
	$Navigation2D/if_build.get_cell(i-5,j-3)==0 and \
	$Navigation2D/if_build.get_cell(i-6,j-3)==0 and \
	$Navigation2D/if_build.get_cell(i-7,j-3)==0 and \
	$Navigation2D/if_build.get_cell(i,j-4)==0 and \
	$Navigation2D/if_build.get_cell(i-1,j-4)==0 and \
	$Navigation2D/if_build.get_cell(i-2,j-4)==0 and \
	$Navigation2D/if_build.get_cell(i-3,j-4)==0 and \
	$Navigation2D/if_build.get_cell(i-4,j-4)==0 and \
	$Navigation2D/if_build.get_cell(i-5,j-4)==0 and \
	$Navigation2D/if_build.get_cell(i-6,j-4)==0 and \
	$Navigation2D/if_build.get_cell(i-7,j-4)==0 and \
	$Navigation2D/if_build.get_cell(i,j-5)==0 and \
	$Navigation2D/if_build.get_cell(i-1,j-5)==0 and \
	$Navigation2D/if_build.get_cell(i-2,j-5)==0 and \
	$Navigation2D/if_build.get_cell(i-3,j-5)==0 and \
	$Navigation2D/if_build.get_cell(i-4,j-5)==0 and \
	$Navigation2D/if_build.get_cell(i-5,j-5)==0 and \
	$Navigation2D/if_build.get_cell(i-6,j-5)==0 and \
	$Navigation2D/if_build.get_cell(i-7,j-5)==0 and \
	$Navigation2D/if_build.get_cell(i,j-6)==0 and \
	$Navigation2D/if_build.get_cell(i-1,j-6)==0 and \
	$Navigation2D/if_build.get_cell(i-2,j-6)==0 and \
	$Navigation2D/if_build.get_cell(i-3,j-6)==0 and \
	$Navigation2D/if_build.get_cell(i-4,j-6)==0 and \
	$Navigation2D/if_build.get_cell(i-5,j-6)==0 and \
	$Navigation2D/if_build.get_cell(i-6,j-6)==0 and \
	$Navigation2D/if_build.get_cell(i-7,j-6)==0 and \
	$Navigation2D/if_build.get_cell(i,j-7)==0 and \
	$Navigation2D/if_build.get_cell(i-1,j-7)==0 and \
	$Navigation2D/if_build.get_cell(i-2,j-7)==0 and \
	$Navigation2D/if_build.get_cell(i-3,j-7)==0 and \
	$Navigation2D/if_build.get_cell(i-4,j-7)==0 and \
	$Navigation2D/if_build.get_cell(i-5,j-7)==0 and \
	$Navigation2D/if_build.get_cell(i-6,j-7)==0 and \
	$Navigation2D/if_build.get_cell(i-7,j-7)==0:
		return true
	else:
		return false

func wei88(i,j):
	$Navigation2D/if_build.set_cell(i,j,1)
	$Navigation2D/if_build.set_cell(i-1,j,1)
	$Navigation2D/if_build.set_cell(i-2,j,1)
	$Navigation2D/if_build.set_cell(i-3,j,1)
	$Navigation2D/if_build.set_cell(i-4,j,1)
	$Navigation2D/if_build.set_cell(i-5,j,1)
	$Navigation2D/if_build.set_cell(i-6,j,1)
	$Navigation2D/if_build.set_cell(i-7,j,1)
	$Navigation2D/if_build.set_cell(i,j-1,1)
	$Navigation2D/if_build.set_cell(i-1,j-1,1) 
	$Navigation2D/if_build.set_cell(i-2,j-1,1)  
	$Navigation2D/if_build.set_cell(i-3,j-1,1)  
	$Navigation2D/if_build.set_cell(i-4,j-1,1) 
	$Navigation2D/if_build.set_cell(i-5,j-1,1)
	$Navigation2D/if_build.set_cell(i-6,j-1,1)
	$Navigation2D/if_build.set_cell(i-7,j-1,1)
	$Navigation2D/if_build.set_cell(i,j-2,1)
	$Navigation2D/if_build.set_cell(i-1,j-2,1)
	$Navigation2D/if_build.set_cell(i-2,j-2,1)
	$Navigation2D/if_build.set_cell(i-3,j-2,1)
	$Navigation2D/if_build.set_cell(i-4,j-2,1)
	$Navigation2D/if_build.set_cell(i-5,j-2,1)
	$Navigation2D/if_build.set_cell(i-6,j-2,1)
	$Navigation2D/if_build.set_cell(i-7,j-2,1)
	$Navigation2D/if_build.set_cell(i,j-3,1)
	$Navigation2D/if_build.set_cell(i-1,j-3,1)
	$Navigation2D/if_build.set_cell(i-2,j-3,1)
	$Navigation2D/if_build.set_cell(i-3,j-3,1)
	$Navigation2D/if_build.set_cell(i-4,j-3,1)
	$Navigation2D/if_build.set_cell(i-5,j-3,1)
	$Navigation2D/if_build.set_cell(i-6,j-3,1)
	$Navigation2D/if_build.set_cell(i-7,j-3,1)
	$Navigation2D/if_build.set_cell(i,j-4,1)
	$Navigation2D/if_build.set_cell(i-1,j-4,1)
	$Navigation2D/if_build.set_cell(i-2,j-4,1)
	$Navigation2D/if_build.set_cell(i-3,j-4,1)
	$Navigation2D/if_build.set_cell(i-4,j-4,1)
	$Navigation2D/if_build.set_cell(i-5,j-4,1)
	$Navigation2D/if_build.set_cell(i-6,j-4,1)
	$Navigation2D/if_build.set_cell(i-7,j-4,1) 
	$Navigation2D/if_build.set_cell(i,j-5,1)
	$Navigation2D/if_build.set_cell(i-1,j-5,1)
	$Navigation2D/if_build.set_cell(i-2,j-5,1)
	$Navigation2D/if_build.set_cell(i-3,j-5,1)
	$Navigation2D/if_build.set_cell(i-4,j-5,1)
	$Navigation2D/if_build.set_cell(i-5,j-5,1)
	$Navigation2D/if_build.set_cell(i-6,j-5,1)
	$Navigation2D/if_build.set_cell(i-7,j-5,1)
	$Navigation2D/if_build.set_cell(i,j-6,1)
	$Navigation2D/if_build.set_cell(i-1,j-6,1)
	$Navigation2D/if_build.set_cell(i-2,j-6,1)
	$Navigation2D/if_build.set_cell(i-3,j-6,1)
	$Navigation2D/if_build.set_cell(i-4,j-6,1)
	$Navigation2D/if_build.set_cell(i-5,j-6,1)
	$Navigation2D/if_build.set_cell(i-6,j-6,1)
	$Navigation2D/if_build.set_cell(i-7,j-6,1) 
	$Navigation2D/if_build.set_cell(i,j-7,1)
	$Navigation2D/if_build.set_cell(i-1,j-7,1)
	$Navigation2D/if_build.set_cell(i-2,j-7,1)
	$Navigation2D/if_build.set_cell(i-3,j-7,1)
	$Navigation2D/if_build.set_cell(i-4,j-7,1)
	$Navigation2D/if_build.set_cell(i-5,j-7,1)
	$Navigation2D/if_build.set_cell(i-6,j-7,1)
	$Navigation2D/if_build.set_cell(i-7,j-7,1)

func update_if_build():
	for i in range(1,100):
		for j in range(1,100):
			$Navigation2D/if_build.set_cell(i,j,0)
	
	for i in range(1,100):
		for j in range(1,100):
			if $YSort/treetile.get_cell(i,j)==0 or \
			$YSort/treetile.get_cell(i,j)==1 or \
			$YSort/treetile.get_cell(i,j)==2 or \
			$YSort/rock.get_cell(i,j)==4 or \
			$YSort/rock.get_cell(i,j)==5 or \
			$YSort/rock.get_cell(i,j)==6 or \
			$YSort/building.get_cell(i,j)==1 or \
			$YSort/building.get_cell(i,j)==2:
				$Navigation2D/if_build.set_cell(i,j,1)
			
	for i in range(1,100):
		for j in range(1,100):
			if $YSort/rock.get_cell(i,j)==1 or \
			$YSort/rock.get_cell(i,j)==0 or \
			$YSort/building.get_cell(i,j)==0:
				rock_wei2(i,j)
	
	for i in range(1,100):
		for j in range(1,100):
			if $YSort/rock.get_cell(i,j)==2:
				rock_wei3(i,j)

func demo_map_load():
	$TileMap.clear()
	$YSort/treetile.clear()
	$YSort/building.clear()
	$YSort/rock.clear()
	$Navigation2D/if_build.clear()
	
	atree()
	
	
	luzhi.load_demo_map=false

func atree():
	$TileMap.clear()
	$YSort/treetile.clear()
	$YSort/building.clear()
	$YSort/rock.clear()
	$Navigation2D/if_build.clear()
	
	for i in range(1,100):
		for j in range(1,100):
			$TileMap.set_cell(i,j,3)
	
	
	var file=File.new()
	if file.file_exists("D:/demo_map.dat"):
		var error=file.open("D:/demo_map.dat",File.READ)
		if error==OK:
			var player_data=file.get_var()
			var tree_array=player_data["world_tree"]
			var rock_array=player_data["world_rock"]
			var building_array=player_data["world_building"]
			
			
			
			var array_num=0
			var numz=0
			for i in range(1,100):
				for j in range(1,100):
					numz=tree_array[array_num]
					if numz>=0:
						$YSort/treetile.set_cell(i,j,numz)
					array_num=array_num+1
			
			array_num=0
			for i in range(1,100):
				for j in range(1,100):
					numz=rock_array[array_num]
					if numz>=0:
						$YSort/rock.set_cell(i,j,numz)
					array_num=array_num+1
			
			array_num=0
			for i in range(1,100):
				for j in range(1,100):
					numz=building_array[array_num]
					if numz>=0:
						$YSort/building.set_cell(i,j,numz)
					array_num=array_num+1
			
			file.close()
	
func _process(delta):
	if luzhi.load_demo_map==true:
		demo_map_load()
		
	if luzhi.start_play==true:
		demo_unit_uptate()
	
func demo_unit_uptate():
	if unit_init==false:
		add_demo_unit()
		unit_init=true

func add_demo_unit():
	db.open_db()
	$YSort/unit.queue_free()
	var unit=_unit.instance()
	$YSort.add_child(unit)
	db.query("SELECT unit_num FROM playdemo GROUP by unit_num")
	for i in range(0,db.query_result.size()):
		var demo_unit=born3.instance()
		unit.add_child(demo_unit)
		demo_unit.unit_num=db.query_result[i]["unit_num"]
	







