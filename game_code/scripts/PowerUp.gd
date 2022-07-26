extends Area2D

export (int) var powerUpType

onready var sprite = $Sprite

func _ready():
	sprite.frame = powerUpType #selecciono el frame a mostrar
	

func _on_PowerUp_body_entered(body):
	if body.is_in_group("player"): #si el body es el player se destruye
		body.shurikenType = powerUpType + 1 #sumo 1 porque los frames no coinciden con los tipos
		queue_free()
