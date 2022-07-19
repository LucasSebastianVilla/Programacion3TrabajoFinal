extends KinematicBody2D

export (PackedScene) var Shuriken

onready var animationPlayer = $AnimationPlayer
onready var sprite = $Sprite
onready var lifeBar = $LifeBar
onready var flashTimer = $FlashTimer
onready var enemyName = $EnemyName

export var shootingTime = 2.0 #tiempo por disparo
export var waitShoot = 1.0 #tiempo de espera hasta el proximo disparo
export var enemyType = 0 #Selecciono el tipo de enemigo para saber como se comporta
						 #0 nada 1 warrior 2 ranger 3 sorcer 4 samurai 5 miniboss 6 boss

var speed = 50 # velocidad del enemigo
var distance = 120 # Distancia entre el enemigo y el player
var moveDireccion = Vector2.ZERO
var dir = Vector2.ZERO
var shootDirecction = 1 #variable para determinar donde debe mirar en idle y para ver donde sale el disparo
var target
var enemyTypeAttack #selecciono el tipo de shuriken que va a tirar
var enemyDamage #tipo de daño que causa al player
var enemyLife = 100 #vida del enemigo

signal dead

func _ready():
	selectTypeEnemy(enemyType)
	moveDireccion.x = -1 #move_left
	animationPlayer.play("walk_left")
	lifeBar.max_value = enemyLife #configuro la vida maxima posible
	lifeBar.value = enemyLife #configuro la vida maxima al iniciar

func flip():
	if $RayDown.is_colliding():
		moveDireccion.y = -1 #move_up
		moveDireccion.x = 0
	if $RayUp.is_colliding():
		moveDireccion.y = 1 #move_down
		moveDireccion.x = 0
	if $RayRight.is_colliding():
		moveDireccion.x = -1 #move_left
		moveDireccion.y = 0
	if $RayLeft.is_colliding():
		moveDireccion.x = 1 #move_right
		moveDireccion.y = 0
	
func _physics_process(delta):
	moveEnemy()
	shootingTime += delta
	move_and_collide(moveDireccion * speed * delta)
	
func moveEnemy():
	setPlayerDirection(moveDireccion)
	if target != null:
		var dist = target.position.distance_to(position)
		dir = position.direction_to(target.position).normalized()
		if dist<distance:
			moveDireccion = Vector2(int(round(dir.x)), int(round(dir.y)))
			if enemyType >= 2:
				shoot()
			if enemyType == 6:
				enemyTypeAttack = 4
				shoot()
	else:
		flip()

func setPlayerDirection(direction): #indico para donde debe mirar y disparar
	if direction.y == -1:
		shootDirecction = 1 #move_up
		animationPlayer.play("walk_up") #move_up
	elif direction.y == 1:
		shootDirecction = 2 #move_down
		animationPlayer.play("walk_down") #move_down
	elif direction.x == -1:
		shootDirecction = 3 #move_left
		animationPlayer.play("walk_left") #move_left
	elif direction.x == 1:
		shootDirecction = 4 #move_right
		animationPlayer.play("walk_right") #move_right
		
func _on_PlayerDetector_body_entered(body):
	if body.is_in_group("player"):
		target = body
	if body.is_in_group("enemies"):
		flip()
	
func _on_PlayerDetector_body_exited(body):
	if body.is_in_group("player"):
		target = null
	
func _on_EnemyBody_area_entered(area):
	if area.is_in_group("weapon"): #si el body es el shuriken muere el enemigo
		if enemyLife > 0: #si es mas de cero le resto vida
			enemyLife -= area.shurikenDamage
			flickerFlash()
			lifeBar.value = enemyLife
		if enemyLife <= 0: #vuelvo a preguntar por si en el golpe anterior lo mata
			queue_free()
			area.queue_free()
	if area.is_in_group("walls"):
		flip()

func shoot():
	if (shootingTime >= waitShoot):
		var shuriken_instance = Shuriken.instance()
		shootingTime = 0
		
		match shootDirecction: #genero el shuriken fuera del player para no colisionar
			1:shuriken_instance.position = Vector2(position.x,position.y - 23)
			2:shuriken_instance.position = Vector2(position.x,position.y + 23)
			3:shuriken_instance.position = Vector2(position.x - 23,position.y)
			4:shuriken_instance.position = Vector2(position.x + 23,position.y)
		
		shuriken_instance.objectToKill = 1 #objetivo player
		shuriken_instance.shurikenDirection = shootDirecction
		shuriken_instance.shurikenType = enemyTypeAttack
		
		get_parent().add_child(shuriken_instance)

func flickerFlash():
	sprite.material.set_shader_param("flashModifier",1)
	sprite.material.set_shader_param("changeSprite",true)
	flashTimer.start()
	
func _on_FlashTimer_timeout():
	sprite.material.set_shader_param("flashModifier",0)
	sprite.material.set_shader_param("changeSprite",false)

func selectTypeEnemy(enemyType):
	match enemyType:
		0: pass #no hay enemigo
		1: #warrior, enemigo simple
			$EnemyName.text = "Warrior"
			enemyDamage = 20 
			enemyLife = 100
		2: #ranger, enemigo que dispara simple
			$EnemyName.text = "Ranger"
			enemyTypeAttack = 0
			enemyDamage = 30
			enemyLife = 150
		3: #sorcer, enemigo con ataque shuriken fuego
			$EnemyName.text = "Sorcer"
			enemyTypeAttack = 1
			enemyDamage = 40
			enemyLife = 200
		4: #samurai, enemigo con ataque shuriken veneno
			$EnemyName.text = "Samurai"
			enemyTypeAttack = 2
			enemyDamage = 50
			enemyLife = 250
		5: #miniboss, enemigo con ataque shuriken hielo
			$EnemyName.text = "Body Guard"
			enemyTypeAttack = 3
			enemyDamage = 60
			enemyLife = 300
		6: #boss, enemigo con ataque shuriken aleatorio en cada tiro
			$EnemyName.text = "Shogun"
			enemyTypeAttack = 0
			enemyDamage = 70
			enemyLife = 400
