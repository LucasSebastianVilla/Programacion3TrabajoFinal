extends KinematicBody2D

export (int) var playerSpeed = 100


func _ready():
	pass # Replace with function body.

func _process(delta):
	var moveDireccion = Vector2.ZERO
	
	if Input.is_action_pressed("ui_up"):
		moveDireccion.y = -1
	if Input.is_action_pressed("ui_down"):
		moveDireccion.y = 1
	if Input.is_action_pressed("ui_left"):
		moveDireccion.x = -1
	if Input.is_action_pressed("ui_right"):
		moveDireccion.x = 1
	
	move_and_slide(moveDireccion * playerSpeed)
	
