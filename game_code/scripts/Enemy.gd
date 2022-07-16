extends KinematicBody2D

export (PackedScene) var Shuriken

onready var animationPlayer = $AnimationPlayer
onready var sprite = $Sprite
onready var lifeBar = $LifeBar
onready var flashTimer = $FlashTimer

export var shootingTime = 2.0 #tiempo por disparo
export var waitShoot = 1.0 #tiempo de espera hasta el proximo disparo
export var enemyLife = 100
export var enemyDamage = 20
export var enemyType = 0 #Selecciono el tipo de enemigo para saber como se comporta
						 #0 nada 1 warrior 2 ranger 3 sorcer 4 samurai 5 miniboss 6 boss

var speed = 50 # velocidad del enemigo
var distance = 120 # Distancia entre el enemigo y el player
var moveDireccion = Vector2.ZERO
var dir = Vector2.ZERO
var shootDirecction = 1 #variable para determinar donde debe mirar en idle y para ver donde sale el disparo
var target

signal dead

func _ready():
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
			if enemyType == 2:
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
		print("Detecta player")
		target = body
	if body.is_in_group("enemies"):
		print("Colision con otro enemigo")
	
func _on_PlayerDetector_body_exited(body):
	if body.is_in_group("player"):
		print("No detecta player")
		target = null
	
func _on_EnemyBody_area_entered(area):
	if area.is_in_group("weapon"): #si el body es el shuriken muere el enemigo
		if enemyLife > 0: #si es mas de cero le resto vida
			enemyLife -= 20
			flickerFlash()
			lifeBar.value = enemyLife
			print("Vida del enemigo " + str(enemyLife))
		if enemyLife <= 0: #vuelvo a preguntar por si en el golpe anterior lo mata
			queue_free()
			area.queue_free()
			#emit_signal("dead")

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
		shuriken_instance.dir = shootDirecction
		get_parent().add_child(shuriken_instance)
		#emit_signal("playerShoot", shuriken_instance, weaponStart.global_position, shuriken_instance.dir)
		print("Tira shuriken enemigo")

func flickerFlash():
	sprite.material.set_shader_param("flashModifier",1)
	sprite.material.set_shader_param("changeSprite",true)
	flashTimer.start()
	
func _on_FlashTimer_timeout():
	sprite.material.set_shader_param("flashModifier",0)
	sprite.material.set_shader_param("changeSprite",false)
