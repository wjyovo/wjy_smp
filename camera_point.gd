extends KinematicBody2D

onready var cur=$cur
var velocity=Vector2.ZERO

func _physics_process(delta):
	if cur.get_global_position().x-self.get_global_position().x>-950:
		velocity=velocity.move_toward(Vector2(4000,0),4000*delta)
	if cur.get_global_position().x-self.get_global_position().x<950:
		velocity=velocity.move_toward(Vector2(-4000,0),4000*delta)
	if cur.get_global_position().y-self.get_global_position().y>-530:
		velocity=velocity.move_toward(Vector2(0,4000),4000*delta)
	if cur.get_global_position().y-self.get_global_position().y<530:
		velocity=velocity.move_toward(Vector2(0,-4000),4000*delta)

	if cur.get_global_position().x>self.get_global_position().x-959 and \
	cur.get_global_position().x<self.get_global_position().x+958 and \
	cur.get_global_position().y>self.get_global_position().y-539 and \
	cur.get_global_position().y<self.get_global_position().y+538:
		velocity=Vector2.ZERO
	move_and_slide(velocity)
