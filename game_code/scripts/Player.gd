extends KinematicBody2D

export (int) var playerSpeed = 100
export (PackedScene) var Shuriken

export var shootingTime = 2.0 #tiempo por disparo
export var waitShoot = 1.0 #tiempo de espera hasta el proximo disparo
export var playerLife = 200 #Vida del player

onready var animationPlayer = $AnimationPlayer
onready var sprite = $Sprite
onready var lifeBar = $LifeBar
onready var flashTimer = $FlashTimer

var idleSide = 4 #variable para determinar donde debe mirar en idle y para ver donde sale el disparo
var shootDirecction = 4
var moveDireccion = Vector2.ZERO

signal playerShoot(shuriken, position, direction)

func _ready():
	animationPlayer.play("idle_right")
	lifeBar.max_value = playerLife #configuro la vida maxima posible
	lifeBar.value = playerLife #configuro la vida maxima al iniciar


func _process(delta):
	movePlayer()
	shootingTime += delta
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

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		shootDirecction=idleSide
		shoot()
		
func shoot():
	if (shootingTime >= waitShoot):
		var shuriken_instance = Shuriken.instance()
		shootingTime = 0
		
		match shootDirecction: #genero el shuriken fuera del player para no colisionar
			1:shuriken_instance.position = Vector2(position.x,position.y - 18)
			2:shuriken_instance.position = Vector2(position.x,position.y + 20)
			3:shuriken_instance.position = Vector2(position.x - 18,position.y)
			4:shuriken_instance.position = Vector2(position.x + 18,position.y)
		
		shuriken_instance.objectToKill = 2 #objetivo enemigo
		shuriken_instance.dir = shootDirecction
		get_parent().add_child(shuriken_instance)
		#emit_signal("playerShoot", shuriken_instance, weaponStart.global_position, shuriken_instance.dir)
		print("Tira shuriken")
		
func _on_PlayerBody_area_entered(area):
	if area.is_in_group("weapon"): #si el body es el shuriken muere el enemigo
		if playerLife > 0: #si es mas de cero le resto vida
			flickerFlash()
			playerLife -= 20
			lifeBar.value = playerLife
			print("Vida del player " + str(playerLife))
		if playerLife <= 0: #vuelvo a preguntar por si en el golpe anterior lo mata
			queue_free()
			area.queue_free()
			print("Player muerto")

func _on_PlayerBody_body_entered(body):
	if body.is_in_group("enemies"):
		print("Player muerto")
		queue_free()

func flickerFlash():
	sprite.material.set_shader_param("flashModifier",1)
	sprite.material.set_shader_param("changeSprite",true)
	flashTimer.start()
	
func _on_FlashTimer_timeout():
	sprite.material.set_shader_param("flashModifier",0)
	sprite.material.set_shader_param("changeSprite",false)
