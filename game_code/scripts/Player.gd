extends KinematicBody2D

export (int) var playerSpeed = 100
export (PackedScene) var Shuriken

onready var animationPlayer = $AnimationPlayer
onready var sprite = $Sprite
onready var weaponStart = $WeaponStart

var idleSide = 0
var moveDireccion = Vector2.ZERO

func _ready():
	animationPlayer.play("idle_right")
	#weaponStart.position.x = 16

func _process(delta):
	movePlayer()
	move_and_slide(moveDireccion * playerSpeed)
	
func movePlayer():
	moveDireccion = Vector2.ZERO
	
	if Input.is_action_pressed("ui_up"):
		animationPlayer.play("walk_up")
		moveDireccion.y = -1
		#weaponStart.position.y += 16
		idleSide=1
	elif Input.is_action_pressed("ui_down"):
		animationPlayer.play("walk_down")
		moveDireccion.y = 1
		#weaponStart.position.y -= 16
		idleSide=2
	elif Input.is_action_pressed("ui_left"):
		animationPlayer.play("walk_left")
		moveDireccion.x = -1
		#weaponStart.position.x -= 16
		idleSide=3
	elif Input.is_action_pressed("ui_right"):
		animationPlayer.play("walk_right")
		moveDireccion.x = 1
		#weaponStart.position.x += 16
		idleSide=4
	else:
		match idleSide:#selecciono para que lado queda mirando el player
			1:	animationPlayer.play("idle_up")
			2:	animationPlayer.play("idle_down")
			3:	animationPlayer.play("idle_left")
			4:	animationPlayer.play("idle_right")

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		shoot()
		
func shoot():	
	var shuriken_instance = Shuriken.instance()
	add_child(shuriken_instance)
	shuriken_instance.global_position = weaponStart.global_position
