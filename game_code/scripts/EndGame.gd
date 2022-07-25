extends Node2D

onready var sprite = $Sprite
onready var label = $Control/Label
onready var musicCondition = $MusicCondition

# Called when the node enters the scene tree for the first time.
func _ready():
	if (Global.gameFinalCondition == 1):
		sprite.texture = ResourceLoader.load("res://assets/win_image.png")
		label.text = "You Win!!!"
		musicCondition.stream = ResourceLoader.load("res://assets/win_music.mp3")
		musicCondition.play()
	else:
		sprite.texture = ResourceLoader.load("res://assets/lose_image.png")
		label.text = "You Lose!!!"
		musicCondition.stream = ResourceLoader.load("res://assets/lose_music.ogg")
		musicCondition.play()
	
