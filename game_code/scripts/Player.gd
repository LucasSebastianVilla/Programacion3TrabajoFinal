extends KinematicBody2D

export (int) var playerSpeed = 100 #velocidad del player
export (PackedScene) var Shuriken #traigo la escena del shuriken

export var shootingTime = 2.0 #tiempo por disparo
export var waitShoot = 0.5 #tiempo de espera hasta el proximo disparo
export (int) var limit_right #esta variable y la de abajo son para asignar el limite de la camara
export (int) var limit_bottom

onready var animationPlayer = $AnimationPlayer
onready var sprite = $Sprite
onready var lifeBar = $LifeBar
onready var flashTimer = $FlashTimer
onready var powerUpTimer = $PowerUpTimer
onready var camera2d = $Camera2D
onready var pickUpSound = $PickUpSound
onready var playerHurt = $PlayerHurt

var floaty_text_scene = preload("res://scenes/FloatingText.tscn")
var playerMaxLife = 300 #Vida del player
var playerLife = playerMaxLife #Vida del player
var playerCollision = false
var idleSide = 4 #variable para determinar donde debe mirar en idle y para ver donde sale el disparo
var shootDirecction = 4
var moveDireccion = Vector2.ZERO
var shurikenType = 0

func _ready():
	self.global_position = Global.player_initial_map_position
	camera2d.limit_right = limit_right
	camera2d.limit_bottom = limit_bottom
	
	idleSide = Global.player_facing_direction
	movePlayer()
	
	lifeBar.max_value = playerLife #configuro la vida maxima posible
	lifeBar.value = playerLife #configuro la vida maxima al iniciar

func _process(delta):
	movePlayer()
	shootingTime += delta
	move_and_slide(moveDireccion * playerSpeed)
	
func movePlayer(): #funcion para movimiento de player
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

func _unhandled_input(event): #si disparo tomo la posicion en la que mira el player
	if event.is_action_pressed("ui_accept"):
		shootDirecction=idleSide
		shoot()
		
func shoot(): #funcion que controla el disparo del shuriken
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
		
		get_parent().add_child(shuriken_instance)
		
func _on_PlayerBody_area_entered(area):
	if area.is_in_group("weapon"): #pregunto si lo que entra en el area es un shuriken
		if !playerCollision: #si recibio un golpe recientemente espera un rato
			enemyDamage(area.shurikenDamage)
	if area.is_in_group("powerup"): #pregunto si lo que entra en el area es un power up
		if Global.fx:
			pickUpSound.play() #sonido del powerup
		
		match area.powerUpType:
			0:	#powerup de shuriken fuego
				powerUpTimer.start() 
				_on_CreateFloatingTextButton("Fire Damage", area.position.x, area.position.y)
			1:	#powerup de shuriken veneno
				powerUpTimer.start() 
				_on_CreateFloatingTextButton("Poison Damage", area.position.x, area.position.y)
			2: #powerup de shuriken hielo
				powerUpTimer.start() 
				_on_CreateFloatingTextButton("Ice Damage", area.position.x, area.position.y)
			3: #powerup de restaurar vida 
				_on_CreateFloatingTextButton("Restore Life", area.position.x, area.position.y)
				playerLife = playerMaxLife
				lifeBar.max_value = playerLife
				lifeBar.value = playerLife
			4: #powerup de incrementar vida permanentemente
				_on_CreateFloatingTextButton("Increase Life", area.position.x, area.position.y)
				playerMaxLife += 100 
				playerLife = playerMaxLife
				lifeBar.max_value = playerLife
				lifeBar.value = playerLife
			5: #powerup de incrementar velocidad
				_on_CreateFloatingTextButton("Increase Speed", area.position.x, area.position.y)
				playerSpeed = 150
				powerUpTimer.start() 

func _on_PlayerBody_body_entered(body):
	if body.is_in_group("enemies"):
		if !playerCollision: #si recibio un golpe recientemente espera un rato
			enemyDamage(body.enemyDamage)

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
		_on_CreateFloatingTextButton("Damage - " + str(damage), position.x, position.y)
		playerLife -= damage
		lifeBar.value = playerLife
		
		if Global.fx:
			playerHurt.play()
	if playerLife <= 0: #vuelvo a preguntar por si en el golpe anterior lo mata
		Global.gameFinalCondition = 2
		get_tree().change_scene("res://scenes/EndGame.tscn")
		queue_free()

func _on_PowerUpTimer_timeout(): #cuando se termine el tiempo la velocidad y el shuriken vuelven a la normalidad
	shurikenType = 0
	playerSpeed = 100
	
func _on_CreateFloatingTextButton(text, x, y): #texto flotante para mostrar los diferentes mensajes
	var floaty_text = floaty_text_scene.instance()
	floaty_text.typeText = 2 #color del texto
	floaty_text.position = Vector2(x, y) #posiciona el texto flotante donde esta el nodo generador
	floaty_text.velocity = Vector2(rand_range(-50, 50), -100) #velocidad de movimiento
	floaty_text.modulate = Color(rand_range(0.7, 1), rand_range(0.7, 1), rand_range(0.7, 1), 1.0)
	
	floaty_text.text = text #texto a mostrar
		
	get_parent().add_child(floaty_text)
