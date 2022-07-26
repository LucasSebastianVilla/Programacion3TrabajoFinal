extends ParallaxBackground

var DIR = Vector2(1,0)
var speed = -25
var control = true #variable de control para que no ingrese al if en cada proceso
onready var bkgMusic = $BkgMusic


func _physics_process(delta):
	if Global.music && control:
		control = false
		bkgMusic.stream_paused = false #uso esta propiedad para reanudar la musica donde quedo
	elif !Global.music:
		bkgMusic.stream_paused = true
		control = true
		
	if Global.parallaxScroll:
		scroll_base_offset += DIR * speed * delta

