extends Area2D

export var shurikenDestroy = 2.5 #tiempo en que se destruye el shuriken
export (int) var shurikenSpeed = 200 #velocidad del shuriken
export (int) var shurikenType = 0 #tipo de shuriken, si tiene power ups o no

onready var animatedSprite = $AnimatedSprite
onready var powerUp = $PowerUp
onready var bkgSound = $BkgSound

var objectToKill = 0 #configuro a quien debe destruir, 0 nadie 1 player 2 enemigos
var shurikenDirection = 0 #direccion del disparo
var shurikenDamage = 30

func _ready():
	shurikenPower(shurikenType)
	if Global.fx:
		bkgSound.play()

func _physics_process(delta):
	match shurikenDirection: #elijo para donde va el shuriken
		1: position.y -= delta * shurikenSpeed
		2: position.y += delta * shurikenSpeed
		3: position.x -= delta * shurikenSpeed
		4: position.x += delta * shurikenSpeed
	
	shurikenDestroy-=delta
	
	if shurikenDestroy<=0:
		queue_free()
		
func _on_Shuriken_body_entered(body):
	if body.is_in_group("player") && objectToKill == 1: #si el body es el player se destruye
		queue_free()
	elif body.is_in_group("enemies") && objectToKill == 2: #si el body es enemigo se destruye
		queue_free()
	else: #si el body es otra cosa se destruye
		queue_free()

func shurikenPower(powerType):
	animatedSprite.material.set_shader_param("changeSprite",powerType)
	animatedSprite.material.set_shader_param("fullSprite",true)
	
	match powerType:
		0: shurikenDamage
		1: shurikenDamage += 30 #fuego
		2: shurikenDamage += 40 #veneno
		3: shurikenDamage += 50 #hielo
		
	powerUp.start() #inicio el power up si tiene

