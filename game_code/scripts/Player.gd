extends KinematicBody2D

export (int) var playerSpeed = 100
export (PackedScene) var Shuriken

export var shootingTime = 2.0 #tiempo por disparo
export var waitShoot = 0.5 #tiempo de espera hasta el proximo disparo
export var playerLife = 200 #Vida del player

onready var animationPlayer = $AnimationPlayer
onready var sprite = $Sprite
onready var lifeBar = $LifeBar
onready var flashTimer = $FlashTimer
onready var powerUpTimer = $PowerUpTimer 

var idleSide = 4 #variable para determinar donde debe mirar en idle y para ver donde sale el disparo
var shootDirecction = 4
var moveDireccion = Vector2.ZERO
var playerCollision = false
var playerDamage = 20
var shurikenType = 0

#signal playerShoot(shuriken, position, direction)

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
		shuriken_instance.shurikenDirection = shootDirecction
		shuriken_instance.shurikenType = shurikenType
		print("Tipo de Shuriken " + str(shurikenType))
		get_parent().add_child(shuriken_instance)
		
func _on_PlayerBody_area_entered(area):
	if area.is_in_group("weapon"): #pregunto si lo que entra en el area es un shuriken
		if !playerCollision: #si recibio un golpe recientemente espera un rato
			enemyDamage(playerDamage)
	if area.is_in_group("powerup"): #pregunto si lo que entra en el area es un power up
		powerUpTimer.start()

func _on_PlayerBody_body_entered(body):
	if body.is_in_group("enemies"):
		if !playerCollision: #si recibio un golpe recientemente espera un rato
			enemyDamage(playerDamage)

func flickerFlash(): #cuando se llama esta func se dispara el timer
	sprite.material.set_shader_param("flashModifier",1)
	sprite.material.set_shader_param("changeSprite",true)
	playerCollision = true
	flashTimer.start()
	
func _on_FlashTimer_timeout(): #cuando se acaba el tiempo vuelve todo a la normalidad
	sprite.material.set_shader_param("flashModifier",0)
	sprite.material.set_shader_param("changeSprite",false)
	playerCollision = false

func enemyDamage(damage): #daño recibido por parte de los enemigos o armas
	if playerLife > 0: #si es mas de cero le resto vida
		flickerFlash()
		playerLife -= damage
		lifeBar.value = playerLife
	if playerLife <= 0: #vuelvo a preguntar por si en el golpe anterior lo mata
		queue_free()

func _on_PowerUpTimer_timeout():
	shurikenType = 0
	
