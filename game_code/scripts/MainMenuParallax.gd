extends ParallaxBackground

var DIR = Vector2(1,0)
var speed = -25

func _physics_process(delta):
	if Global.parallaxScroll:
		scroll_base_offset += DIR * speed * delta

