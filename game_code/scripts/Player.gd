extends KinematicBody2D

export (int) var playerSpeed = 100
onready var animationPlayer = $AnimationPlayer
onready var sprite = $Sprite
var idleSide = 0
var moveDireccion = Vector2.ZERO

func _ready():
	animationPlayer.play("idle_right")

func _process(delta):
	movePlayer()
	move_and_slide(moveDireccion * playerSpeed)
	
func movePlayer():
	moveDireccion = Vector2.ZERO
	
	if Input.is_action_pressed("ui_up"):
		animationPlayer.play("walk_up")
		moveDireccion.y = -1
		idleSide=1
	elif Input.is_action_pressed("ui_down"):
		animationPlayer.play("walk_down")
		moveDireccion.y = 1
		idleSide=2
	elif Input.is_action_pressed("ui_left"):
		animationPlayer.play("walk_left")
		moveDireccion.x = -1
		idleSide=3
	elif Input.is_action_pressed("ui_right"):
		animationPlayer.play("walk_right")
		moveDireccion.x = 1
		idleSide=4
	else:
		match idleSide:#selecciono para que lado queda mirando el player
			1:	animationPlayer.play("idle_up")
			2:	animationPlayer.play("idle_down")
			3:	animationPlayer.play("idle_left")
			4:	animationPlayer.play("idle_right")
