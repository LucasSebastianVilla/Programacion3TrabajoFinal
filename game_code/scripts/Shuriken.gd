extends Area2D

export var destroyShuriken = 2.5 #tiempo en que se destruye el shuriken
export (int) var velocidad = 200 #velocidad del shuriken

var objectToKill = 0 #configuro a quien debe destruir, 0 nadie 1 player 2 enemigos
var dir = 0 #direccion del disparo

func _ready():
	pass
	#connect("area_entered",self,"_on_shoot_body_entered")

func _physics_process(delta):
	match dir: #elijo para donde va el shuriken
		1: position.y -= delta * velocidad
		2: position.y += delta * velocidad
		3: position.x -= delta * velocidad
		4: position.x += delta * velocidad
	
	destroyShuriken-=delta
	
	if destroyShuriken<=0:
		queue_free()

func _on_Shuriken_body_entered(body):
	if body.is_in_group("player") && objectToKill == 1: #si el body es el player se destruye
		print("Mata player")
		queue_free()
	elif body.is_in_group("enemies") && objectToKill == 2: #si el body es enemigo se destruye
		print("Mata enemigos")
		queue_free()
	else: #si el body es otra cosa se destruye
		print("se rompe contra los objetos")
		queue_free()
