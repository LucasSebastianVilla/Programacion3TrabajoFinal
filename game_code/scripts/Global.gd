extends Node
#Para usar un script global se debe declarar en Configuracion de Proyecto->Autoload

var player_initial_map_position = Vector2(18, 152) #inicio del player
var player_door_map_position = Vector2.ZERO
var player_facing_direction = 4 #orientacion del player
var scene_to_back = "" #escena donde regresa
var gameFinalCondition = 1 #1 gana 2 pierde
var parallaxScroll = true #controlo el parallax del menu
var music = true #controlo la musica ambiental 
var fx = true #controlo los sonidos fx

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventKey and event.scancode == KEY_R:#si presiono R reinicio el juego
		get_tree().change_scene("res://scenes/Level1.tscn")
