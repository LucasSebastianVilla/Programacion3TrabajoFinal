extends KinematicBody2D

onready var animationPlayer = $AnimationPlayer
onready var sprite = $Sprite

var velocidad = 50 # velocidad del enemigo
var distancia = 120 # Distancia entre el enemigo y el player
var moveDireccion = Vector2.ZERO
var dir = Vector2.ZERO

var target
var random_motion

signal dead

func _ready():
	moveDireccion.x = -1 #move_left
	animationPlayer.play("walk_left")
	
	#random_motion = RandomNumberGenerator.new()
	#random_motion.randomize()

func flip():
	if $RayUp.is_colliding():
		moveDireccion.y = 1 #move_down
		animationPlayer.play("walk_down")
	if $RayDown.is_colliding():
		moveDireccion.y = -1 #move_up
		animationPlayer.play("walk_up")
	if $RayLeft.is_colliding():
		moveDireccion.x = 1 #move_right
		animationPlayer.play("walk_right")
	if $RayRight.is_colliding():
		moveDireccion.x = -1 #move_left
		animationPlayer.play("walk_left")

func _physics_process(delta):
	moveEnemy()
	move_and_collide(moveDireccion * velocidad * delta)
	
func moveEnemy():
	if target != null:
		# se podria hacer un raycast para que no siga a traves de las paredes y otras cosas
		var dist = target.position.distance_to(position)
		dir = position.direction_to(target.position)
	
		if dist<distancia:
			moveDireccion = dir

	else:
		flip()
		
""""	var direcEnemy = random_motion.randi_range(1, 4)
		moveDireccion = Vector2.ZERO
		
		match direcEnemy:#de acuerdo al numero es el movimiento
			1:
				moveDireccion.y = -1 #move_up
				animationPlayer.play("walk_up")
			2:
				moveDireccion.y = 1 #move_down
				animationPlayer.play("walk_down")
			3:
				moveDireccion.x = -1 #move_left
				animationPlayer.play("walk_left")
			4:
				moveDireccion.x = 1 #move_right
				animationPlayer.play("walk_right")
	
"""
func _on_Area2D_area_entered(area):
	print("Enemigo muerto")
	queue_free()
	emit_signal("dead")

func _on_Area2D_body_entered(body):
	body.hit()

func _on_PlayerDetector_body_entered(body):
	target = body

func _on_PlayerDetector_body_exited(body):
	target = null
