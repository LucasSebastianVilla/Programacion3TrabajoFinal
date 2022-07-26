extends Node

onready var bkgMusic = $BkgMusic
var control = true

func _ready():
	pass # Replace with function body.

func _process(delta):
	if Global.music && control:
		control = false
		bkgMusic.stream_paused = false #uso esta propiedad para reanudar la musica donde quedo
	elif !Global.music:
		bkgMusic.stream_paused = true
		control = true
